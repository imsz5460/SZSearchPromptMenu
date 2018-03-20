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
    _arrOfSearchBoxes = nil;
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

- (instancetype)initWithMenus:(NSArray *)menus {
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
    
   
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

//    在子视图范围内依旧返回子视图
    NSArray<UIView *> * superViews = self.currentSuperView.subviews;
    // 倒序 从最上面的一个视图开始查找
    for (NSUInteger i = superViews.count; i > 0; i--) {
        UIView * subview = superViews[i - 1];
        // 转换坐标系 使坐标基于子视图
        CGPoint newPoint = [self convertPoint:point toView:subview];
        
        // 得到子视图 hitTest 方法返回的值
        if ([subview class] == [SZSearchPromptMenu class] ) {
            CGPoint redCenterInBlueView = [self convertPoint:point toView:self.menuContainerView];
            BOOL isInside = [self.menuContainerView pointInside:redCenterInBlueView withEvent:nil];
            if (isInside) {
                 return [super hitTest:point withEvent:event];
            } else
            continue;
        }
        
        UIView * fitView = [subview hitTest:newPoint withEvent:event];
        // 如果子视图返回一个view 就直接返回 不再继续遍历
        if (fitView) {
            if (fitView == subview) {
                 [self dissMissPopMenuAnimatedOnMenuSelected:NO];
            }
            return fitView;
        }
    }
     [self dissMissPopMenuAnimatedOnMenuSelected:NO];
    
    return self;
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

static NSString *textLabeltext;
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
