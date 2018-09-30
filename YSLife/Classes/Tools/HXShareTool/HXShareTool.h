//
//  HXShareTool.h
//  YSLife
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface HXShareTool : NSObject

@property (nonatomic, strong) User *currentUser;

+ (instancetype) sharedInstance;

@end
