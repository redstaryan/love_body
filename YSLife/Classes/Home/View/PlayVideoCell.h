//
//  PlayVideoCell.h
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVVideoModel.h"
#import "GlobalDefines.h"

@interface PlayVideoCell : UITableViewCell

@property (nonatomic, strong) UIView *playVideoView;

@property (nonatomic, strong) AVVideoModel *avVideoModel;

/**
 *  播放
 */
- (void)av_playerItemPlaying;

@end
