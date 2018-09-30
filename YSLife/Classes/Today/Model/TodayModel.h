//
//  TodayModel.h
//  YSLife
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 redstar. All rights reserved.
//

typedef enum {
    TodayTypeBreakFast = 1,
    TodayTypLunch = 2,
    TodayTypeDinner = 3,
    TodayTypeSleep = 4
} TodayType;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLPhotoActionSheet.h"

@interface TodayModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, assign) TodayType todayType;
@property (nonatomic, strong) NSArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSArray<PHAsset *> *lastSelectAssets;
@end
