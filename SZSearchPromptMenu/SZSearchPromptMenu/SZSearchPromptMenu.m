//
//  XHPopMenu.m
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import "SZSearchPromptMenu.h"
#import "SZSearchPromptCell.h"

@interface SZSearchPromptMenu () <UITableViewDelegate, UITableViewDataSource> {
    BOOL didClearedHistroy;
}

@property (nonatomic, strong) UIImageView *menuContainerView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menus;

@property (nonatomic, weak) UIView *currentSuperView;
@property (nonatomic, assign) CGPoint targetPoint;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *touchView;//响应事件的views

@property (nonatomic, strong) NSMutableArray *arrOfSearchBoxes;/**< 搜索范围 */
@property (nonatomic, strong) NSMutableArray *arrOfSearchResults;/**< 搜索结果 */

@property (nonatomic, strong) NSMutableArray <SZSearchPromptMenuItem *>*arrOfSearchBoxItems;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) UIButton *clearHistoryButton;//清除列表记录button；
@property (nonatomic, assign) BOOL isShowClearHistoryButton;

@end

@implementation SZSearchPromptMenu

#pragma mark - 显示
- (void)showMenuAtPoint:(CGPoint)point {
    [self showMenuOnView:[[UIApplication sharedApplication] keyWindow] atPoint:point];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point {
    self.currentSuperView = view;
    self.targetPoint = point;

    [self showMenu];
    //按钮集合，用于触摸事件过滤
    self.touchView = [NSMutableArray array];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self findSubView:self.superview];
    });
}

- (void) showClearButton {
    _isShowClearHistoryButton = YES;
}

#pragma mark - 搜索匹配，关键字高亮
- (void)searchWithText:(NSString *)text {
    _searchText = text;
    
    // 获取关键字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", text];
    // 用关键字过滤数组中的内容, 将过滤后的内容放入结果数组
    self.arrOfSearchResults = [[self.arrOfSearchBoxes filteredArrayUsingPredicate:predicate] mutableCopy];
    
   //清空 arrOfSearchBoxItems 数据；
    if (_arrOfSearchBoxItems.count) {
        [_arrOfSearchBoxItems removeAllObjects];
    }
   //对应原数组的索引创建搜索结果集模型数组
    for (NSString *title in self.arrOfSearchResults) {
       [self.arrOfSearchBoxItems addObject: self.menus[[self.arrOfSearchBoxes indexOfObject:title]]  ];
    }
   
    [self.menuTableView reloadData];
}



#pragma mark - animation

- (void)showMenu {
    if (didClearedHistroy) {
        return;
    }
    
    _arrOfSearchResults = nil;
    [self.menuTableView reloadData];
    
    if (![self.currentSuperView.subviews containsObject:self]) {
        self.alpha = 0.0;
        [self.currentSuperView addSubview:self];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected:NO];
    }
}

- (void)dissMissPopMenuAnimatedOnMenuSelected:(BOOL)selected {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (selected) {
            if (self.popMenuDidDismissCompled) {
                self.popMenuDidDismissCompled(self.indexPath.row, self.menus[self.indexPath.row]);
            }
        }
        [super removeFromSuperview];
    }];
}


#pragma mark - Propertys

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {
        _menuContainerView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MoreFunctionFrame"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 50) resizingMode:UIImageResizingModeTile]];
        _menuContainerView.userInteractionEnabled = YES;
        

        [_menuContainerView addSubview:self.menuTableView];
       
    }
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, kXHMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), (CGRectGetHeight(_menuContainerView.bounds) - kXHMenuTableViewSapcing - (_isShowClearHistoryButton? kXHMenuItemViewHeight : 0))) style:UITableViewStylePlain];
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.separatorColor = [UIColor clearColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = kXHMenuItemViewHeight;
        _menuTableView.scrollEnabled = YES;
    }
    return _menuTableView;
    
}

-(UIButton *)clearHistoryButton {
    if (!_clearHistoryButton) {
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [clearBtn setFrame:CGRectMake(0, (CGRectGetHeight(_menuContainerView.bounds) - kXHMenuItemViewHeight), CGRectGetWidth(_menuContainerView.bounds), kXHMenuItemViewHeight  ) ];

        [clearBtn setTintColor:[UIColor redColor]];
        [clearBtn setTitle:@"清除记录" forState: 0];
        [clearBtn addTarget:self action:@selector(didClickClearButton) forControlEvents:UIControlEventTouchUpInside];
        
        _clearHistoryButton = clearBtn;
    }
    return _clearHistoryButton;
    
}
-(NSMutableArray <SZSearchPromptMenuItem *>*)arrOfSearchBoxItems {
    if (!_arrOfSearchBoxItems) {
        _arrOfSearchBoxItems = [NSMutableArray array];
    }
    return _arrOfSearchBoxItems;
}

-(NSMutableArray *)arrOfSearchBoxes {
    if (!_arrOfSearchBoxes) {
        _arrOfSearchBoxes = [NSMutableArray array];
        
        for (SZSearchPromptMenuItem  *eachItem in self.menus) {
            [_arrOfSearchBoxes addObject:eachItem.title];
        }
    }
    return _arrOfSearchBoxes;
}

-(NSMutableArray *)arrOfSearchResults {
    if (!_arrOfSearchResults) {
        _arrOfSearchResults = [NSMutableArray array];
    }
    return _arrOfSearchResults;
}


#pragma mark - 清除历史记录按钮点击事件
-(void) didClickClearButton {
    //点击标记
    didClearedHistroy = YES;
//    清除数组
    [self.menus removeAllObjects];
    [self.menuTableView reloadData];
    
//    告知外界
    if (self.popMenuDidClearedHistroyCompled) {
        self.popMenuDidClearedHistroyCompled();
    }
    
}


#pragma mark - Life Cycle

- (void)setup {

    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.menuContainerView];
}

- (id)initWithMenus:(NSArray *)menus {
    self = [super init];
    if (self) {
        self.menus = [[NSMutableArray alloc] initWithArray: menus];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        SZSearchPromptMenuItem *eachItem;
        va_list argumentList;
        if (firstObj) {
            [menuItems addObject:firstObj];
            va_start(argumentList, firstObj);
            while((eachItem = va_arg(argumentList, SZSearchPromptMenuItem *))) {
                [menuItems addObject:eachItem];
            }
            va_end(argumentList);
        }
        self.menus = menuItems;
        [self setup];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected: NO];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.frame = [[UIScreen mainScreen] bounds];
    
    if (_isShowClearHistoryButton) {
        _menuContainerView.frame = CGRectMake(self.targetPoint.x, self.targetPoint.y, kXHMenuTableViewWidth, self.menus.count >5? 6 * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + kXHMenuTableViewSapcing : (self.menus.count+1) * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + kXHMenuTableViewSapcing);
        _menuTableView.frame = CGRectMake(0, kXHMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), (CGRectGetHeight(_menuContainerView.bounds) - kXHMenuTableViewSapcing -  kXHMenuItemViewHeight));
        [_menuContainerView addSubview:self.clearHistoryButton];
    } else {
        
        _menuContainerView.frame = CGRectMake(self.targetPoint.x, self.targetPoint.y, kXHMenuTableViewWidth, self.menus.count >5? 5 * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + kXHMenuTableViewSapcing : (self.menus.count) * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + kXHMenuTableViewSapcing);
        _menuTableView.frame = CGRectMake(0, kXHMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), (CGRectGetHeight(_menuContainerView.bounds) - kXHMenuTableViewSapcing ));
        
    }
    
   
    [_menuContainerView addSubview:self.clearHistoryButton];
    
}

#pragma mark - 遍历查找子控件
-(void)findSubView:(UIView*)view
{
    for (UIView* subView in view.subviews)
    {
        if ([view isKindOfClass: [UIButton class]]) {
            
            [self.touchView addObject: view];
        }
        [self findSubView:subView];
    }
}

#pragma mark - 拦截响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.touchView.count) {
        
        for (UIView*view in self.touchView) {
            CGPoint btnP = [self convertPoint:point toView:view];
            
            // 判断下点在不在按钮上
            if ([view pointInside:btnP withEvent:event]) {
                return view;
            }
    }
    }
     return [super hitTest:point withEvent:event];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 显示搜索结果时
    if (self.arrOfSearchResults.count) {
        
        //隐藏掉清除按钮
        if (_isShowClearHistoryButton) {
            _clearHistoryButton.hidden = YES;
        }
        //以搜索结果的个数返回行数
        return self.arrOfSearchResults.count;
    }

    _clearHistoryButton.hidden = NO;
    //没有搜索时显示所有数据
//  return self.arrOfSearchBoxes.count;
    return self.menus.count;
}

NSString *textLabeltext;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifer";

    SZSearchPromptCell *searchPromptCell = (SZSearchPromptCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifer];
   
    if (!searchPromptCell) {
        searchPromptCell = [[SZSearchPromptCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifer];
       }
    
    switch (self.arrOfSearchResults.count) {
        case 0:
            if (indexPath.row < self.menus.count) {
                [searchPromptCell setupPopMenuItem:self.menus[indexPath.row] atIndexPath:indexPath isBottom:(indexPath.row == self.menus.count - 1)];
                
                textLabeltext = searchPromptCell.textLabel.text;
                //去除富文本格式；
                searchPromptCell.textLabel.attributedText = nil;
                searchPromptCell.textLabel.text = textLabeltext;
            }
            break;
            
        default:
            
            if (indexPath.row < self.arrOfSearchBoxItems.count) {
                [searchPromptCell setupPopMenuItem:self.arrOfSearchBoxItems[indexPath.row] atIndexPath:indexPath isBottom:(indexPath.row == self.menus.count - 1)];
                
                // 原始搜索结果字符串.
                NSString *originResult = self.arrOfSearchResults[indexPath.row];
                
                // 获取关键字的位置
                NSRange range = [originResult rangeOfString:_searchText];
                
                // 转换成可以操作的字符串类型.
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
                
                // 添加属性(粗体)
                [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
                
                // 关键字红色
                [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                
                // 将带属性的字符串添加到cell.textLabel上.
                [searchPromptCell.textLabel setAttributedText:attribute];
            }
            
            break;
    }
 
    return searchPromptCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    [self dissMissPopMenuAnimatedOnMenuSelected:YES];
    if (self.popMenuDidSlectedCompled) {
        self.popMenuDidSlectedCompled(indexPath.row, self.menus[indexPath.row]);
    }
}

- (void)dealloc
{
    
}

@end
