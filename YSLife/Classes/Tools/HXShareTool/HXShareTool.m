//
//  HXShareTool.m
//  YSLife
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXShareTool.h"

static HXShareTool * _instance = nil;

@implementation HXShareTool

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
    });
    return _instance;
}

+ (instancetype) sharedInstance {
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
