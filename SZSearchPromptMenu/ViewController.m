//
//  ViewController.m
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//


/**
 *  本demo预期效果：
 *  输入任意字符后，点击查询，即保存到了历史记录。下次输入时输入框下方列表会有该历史记录，点击该条目自动填充输入。
 *  多个记录条目按时间由远及近排列，且去除重复条目。
 *  即时搜索匹配，关键字高亮。
 *  一键清除历史记录。
 *  说明：SZSearchPromptMenu是在XHPopMenu的基础上进行了较大的修改及扩展，XHPopMenu的功能为pop菜单。感谢作者曾宪华(@xhzengAIB)。实际上SZSearchPromptMenu保留了弹出菜单的功能。
 *
 */

#import "ViewController.h"
#import "SZSearchPromptMenu.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *historyList;//查询历史记录
@property(nonatomic,strong)SZSearchPromptMenu *popView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _textField.delegate = self;
   

}

#pragma mark -- 初始化列表框
-(SZSearchPromptMenu *)popView{
    
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
        [_popView showClearButton];//显示清除历史记录的按钮，如果不需要则注释该行
    }
    
    return _popView;
}

#pragma mark -- 懒加载historyList
-(NSMutableArray *)historyList {
    if (!_historyList) {
        _historyList = [NSMutableArray array];
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: @"HistoryList-拼接userId"];//可以用如userId隔离不同的账户
        [_historyList addObjectsFromArray:arr];
    }
    return _historyList;
}

#pragma mark - 点击列表项的回调
- (void)listenPopSelcted {
    
    __weak typeof (self)weakSelf = self;
    _popView.popMenuDidDismissCompled = ^(NSInteger index, SZSearchPromptMenuItem *menuItem){
        weakSelf.textField.text = menuItem.title;
    };
    
//    点击清除列表记录的按钮的回调，如果没有开启该功能（默认没有开启），则无需实现该方法
    _popView.popMenuDidClearedHistroyCompled = ^{
        [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"HistoryList-拼接userId"];
        _historyList = nil;
    };
    
}

- (IBAction)query:(id)sender {
  
    

//  按时间由近及远排序，且对历史记录列表去重。
    
    if (![self.historyList.lastObject isEqualToString: self.textField.text]) {
        [_historyList addObject: self.textField.text];
        
        NSMutableArray *listAry = [[NSMutableArray alloc] init];
        for (NSString *str in [[_historyList reverseObjectEnumerator] allObjects]) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        
//  对历史记录进行本地持久保存
        [[NSUserDefaults standardUserDefaults] setObject: [[listAry reverseObjectEnumerator] allObjects] forKey: @"HistoryList-拼接userId"];
        _popView = nil;//下次需要刷新
        _historyList = nil;
    }
}



-(void)addAction {
    
    [self.popView showMenuOnView:self.view atPoint:CGPointMake(20, 92)];
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
    
//    搜索匹配功能，关键字高亮。如果不需要搜索匹配，注释此方法即可。
    [self.popView searchWithText: text];

    return YES;
}

#pragma mark -点击空白处键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        [self.view endEditing: YES];
    }
}

- (void)dealloc
{
    
}

@end
