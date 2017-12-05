//
//  SZSearchPromptMenuItem.h
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kXHMenuTableViewWidth 92
#define kXHMenuTableViewSapcing 7

#define kXHMenuItemViewHeight 32
#define kXHMenuItemViewImageSapcing 15
#define kXHSeparatorLineImageViewHeight 0.5


@interface SZSearchPromptMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
