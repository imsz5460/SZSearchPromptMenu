//
//  SZSearchTextfield.m
//  SZSearchPromptMenu
//
//  Created by Yjt on 2018/3/19.
//  Copyright © 2018年 shizhi. All rights reserved.
//

#import "SZSearchTextfield.h"
#import "SZSearchPromptMenu.h"

@interface SZSearchTextfield()

@property (nonatomic, strong) NSMutableArray *historyList;//查询历史记录
@property (nonatomic, strong) SZSearchPromptMenu *popView;

@end

@implementation SZSearchTextfield

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.delegate = self;
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    _showClearHistoryButton = YES;
    _allowSearch = YES;
    [self addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- 初始化列表框
-(SZSearchPromptMenu *)popView {
    
    if (!_popView) {
        //添加+ items
        NSMutableArray *listArr = [NSMutableArray array];
        if (self.historyList.count == 0) {
            return nil;
        }
        NSArray *tempArr = [[self.historyList reverseObjectEnumerator] allObjects];
        
        for (NSString *object in tempArr) {
            SZSearchPromptMenuItem *item = [[SZSearchPromptMenuItem alloc] initWithImage: nil title: object];
            [listArr addObject: item];
        }
        _popView = [[SZSearchPromptMenu alloc] initWithMenus: listArr];
        
        //监听列表点击
        [self listenPopSelcted];
        if (_showClearHistoryButton) {
              [_popView showClearButton];//显示清除历史记录的按钮
        }      
    }
    
    return _popView;
}

#pragma mark -- 懒加载historyList
-(NSMutableArray *)historyList {
    if (!_historyList) {
        _historyList = [NSMutableArray array];
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HistoryList-%@",  self.userID ]];//可以用如userId隔离不同的账户
        [_historyList addObjectsFromArray:arr];
    }
    return _historyList;
}

#pragma mark - 点击列表项的回调
- (void)listenPopSelcted {
    
    __weak typeof (self)weakSelf = self;
    _popView.popMenuDidDismissCompled = ^(NSInteger index, SZSearchPromptMenuItem *menuItem){
        weakSelf.text = menuItem.title;
    };
    if (_showClearHistoryButton) {
    //  点击清除列表记录的按钮的回调，如果没有开启该功能（默认没有开启），则无需实现该方法
    _popView.popMenuDidClearedHistroyCompled = ^{
        [[NSUserDefaults standardUserDefaults] setObject: nil forKey: [NSString stringWithFormat:@"HistoryList-%@",  weakSelf.userID ]];
        _historyList = nil;
    };
    }
}

- (void)query:(id)sender {
    //  按时间由近及远排序，且对历史记录列表去重。
    
    if (![self.historyList.lastObject isEqualToString: self.text]) {
        [_historyList addObject: self.text];
        
        NSMutableArray *listAry = [[NSMutableArray alloc] init];
        for (NSString *str in [[_historyList reverseObjectEnumerator] allObjects]) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        
        //  对历史记录进行本地持久保存
        [[NSUserDefaults standardUserDefaults] setObject: [[listAry reverseObjectEnumerator] allObjects] forKey: [NSString stringWithFormat:@"HistoryList-%@",  self.userID ]];
        _popView = nil;//下次需要刷新
        _historyList = nil;
    }
}


-(void)addAction {
    CGPoint point = [self.superview convertPoint:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame))  toView:[UIApplication sharedApplication].keyWindow];
//  [self.popView showMenuOnView:self.view atPoint:CGPointMake(20, 92)];
    [self.popView showMenuAtPoint:point];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self addAction];
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.popView dissMissPopMenuAnimatedOnMenuSelected: NO];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    NSLog(@"======%@======%@=",text,textField.text);
//    if (_allowSearch) {
////          搜索匹配功能，关键字高亮。
//        [self.popView searchWithText: text];
//    }
    
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
    NSLog(@"ssss=======%@=",textField.text);
    if (_allowSearch) {
     [self.popView searchWithText: textField.text];
    }
}

- (void)dealloc
{
    
}


@end
