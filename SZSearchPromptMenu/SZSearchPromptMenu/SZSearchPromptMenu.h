//
//  XHPopMenu.h
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SZSearchPromptMenuItem.h"

typedef void(^PopMenuDidSlectedCompledBlock)(NSInteger index, SZSearchPromptMenuItem *menuItem);
typedef void(^PopMenuDidClearedCompledBlock)(void);
@interface SZSearchPromptMenu : UIView

- (instancetype)initWithMenus:(NSArray *)menus;

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showMenuAtPoint:(CGPoint)point;

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;

@property (nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidSlectedCompled;

@property (nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidDismissCompled;

@property (nonatomic, copy) PopMenuDidClearedCompledBlock popMenuDidClearedHistroyCompled;


- (void)dissMissPopMenuAnimatedOnMenuSelected:(BOOL)selected;

//搜索匹配
- (void)searchWithText:(NSString *)text;

//显示清除历史记录的按钮
- (void)showClearButton;

@end
