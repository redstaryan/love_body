//
//  NewsDetailImgModel.m
//  YSLife
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "NewsDetailImgModel.h"

@implementation NewsDetailImgModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {//一定要调回父类的方法
        self.ref = dict[@"ref"];
        self.pixel = dict[@"pixel"];
        self.src = dict[@"src"];
    }
    return self;
}

+(instancetype)detailImgWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];//这里一定要用self
}

@end
