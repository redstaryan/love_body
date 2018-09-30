//
//  HXAnimation.m
//  YSLife
//
//  Created by admin on 2018/6/16.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXAnimation.h"

@implementation HXAnimation

//CABasicAnimation 实现旋转动画
+ (void)rotateView:(UIImageView *)view
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 12;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//暂停动画
+ (void)pauseAnimation:(UIImageView *)view
{
    //（0-5）
    //开始时间：0
    //    myView.layer.beginTime
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    view.layer.timeOffset = pauseTime;
    
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    view.layer.speed = 0;
}

//恢复动画
+ (void)resumeAnimation:(UIImageView *)view
{
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = view.layer.timeOffset;
    
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    
    [view.layer setTimeOffset:0];
    [view.layer setBeginTime:begin];
    
    view.layer.speed = 1;
}

@end
