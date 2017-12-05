//
//  SZSearchPromptMenuItem.h
//  SZSearchPromptMenu
//
//  Created by ShiZhi on 2017/12/4.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import "SZSearchPromptMenuItem.h"

@implementation SZSearchPromptMenuItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
    }
    return self;
}

@end
