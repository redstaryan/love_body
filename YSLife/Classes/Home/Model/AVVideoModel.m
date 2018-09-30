//
//  AVVideoModel.m
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "AVVideoModel.h"
#import "GlobalDefines.h"

@implementation AVVideoModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"videoId":@"id",
             @"videourl":@"videourl",
             @"describe":@"describe",
             @"imageurl":@"imageurl",
             @"category":@"category",
             @"videotype":@"category"};
}

@end
