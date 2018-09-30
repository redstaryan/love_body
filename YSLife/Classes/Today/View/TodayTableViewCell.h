//
//  TodayTableViewCell.h
//  YSLife
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayModel.h"

@protocol TodayTableViewCellDelegate<NSObject>
@optional
-(void)didClickCameraButton:(NSIndexPath *)indexPath;
-(void)didClickSendButton:(NSIndexPath *)indexPath;
@end

@interface TodayTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) TodayModel *todayModel;

@property(nonatomic,weak) id<TodayTableViewCellDelegate>delegate;

@end
