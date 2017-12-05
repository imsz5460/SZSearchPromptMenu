//
//  SZSearchPromptCell.h
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SZSearchPromptMenuItem.h"

@interface SZSearchPromptCell : UITableViewCell

@property (nonatomic, strong) SZSearchPromptMenuItem *popMenuItem;

- (void)setupPopMenuItem:(SZSearchPromptMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom;

@end
