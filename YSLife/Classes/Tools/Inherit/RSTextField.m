//
//  RSTextField.m
//  YSLife
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "RSTextField.h"

@implementation RSTextField

- (BOOL)isEmpty
{
    BOOL result = NO;
    if (self.text.length == 0) {
        result = YES;
    }
    return result;
}

@end
