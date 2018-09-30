//
//  HXAnimation.h
//  YSLife
//
//  Created by admin on 2018/6/16.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXAnimation : NSObject

+ (void)rotateView:(UIImageView *)view;

//暂停动画
+ (void)pauseAnimation:(UIImageView *)view;

//恢复动画
+ (void)resumeAnimation:(UIImageView *)view;

@end
