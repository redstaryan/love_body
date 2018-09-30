//
//  User.m
//  YSLife
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"videoId":@"id",
             @"videourl":@"videourl",
             @"describe":@"describe",
             @"imageurl":@"imageurl",
             @"category":@"category",
             @"videotype":@"category"};
}

@end
