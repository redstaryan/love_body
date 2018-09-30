//
//  TodayCardView.h
//  YSLife
//
//  Created by admin on 2018/5/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "TodayModel.h"

@protocol TodayCardViewDelegate<NSObject>
@optional
-(void)didClickButton:(BOOL)isEat todayModel:(TodayModel *)todayModel;
@end

@interface TodayCardView : BaseView

@property (nonatomic, assign) TodayType todayType;

@property(nonatomic,weak) id<TodayCardViewDelegate>delegate;

@property (nonatomic, strong) UIViewController *fatherViewController;
@end
