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
 *  多个记录条目按时间由近及远排列，且去除重复条目。
 *  即时搜索匹配，关键字高亮。
 *  一键清除历史记录。
 *  说明：SZSearchPromptMenu是在XHPopMenu的基础上进行了较大的修改及扩展，XHPopMenu的功能为pop菜单。感谢作者曾宪华(@xhzengAIB)。实际上SZSearchPromptMenu保留了弹出菜单的功能。
 *
 */


#import "ViewController.h"
#import "SZSearchTextfield.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SZSearchTextfield *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.textField.allowSearch = NO;///是否开启搜索匹配功能，默认开启
//    self.textField.showClearHistoryButton = NO;///是否开启删除记录按钮，默认开启
}


- (IBAction)query:(id)sender {
    
    [_textField query:nil];
    
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
