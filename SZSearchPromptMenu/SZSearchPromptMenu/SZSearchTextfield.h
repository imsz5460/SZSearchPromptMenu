//
//  SZSearchTextfield.h
//  SZSearchPromptMenu
//
//  Created by Yjt on 2018/3/19.
//  Copyright © 2018年 shizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSearchTextfield : UITextField<UITextFieldDelegate>
@property (nonatomic, assign) BOOL showClearHistoryButton;//默认显示
@property (nonatomic, assign) BOOL allowSearch;//默认允许
@property (nonatomic, copy) NSString *userID;//用于区分不同用户进行存储

- (void)query:(id)sender;
@end
