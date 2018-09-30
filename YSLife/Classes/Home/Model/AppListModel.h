//
//  AppListModel.h
//  YSLife
//
//  Created by admin on 2018/6/5.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppListModel : NSObject
@property (nonatomic, copy) NSString *appImage;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appType;
@property (nonatomic, copy) NSString *jumpType;
@end
