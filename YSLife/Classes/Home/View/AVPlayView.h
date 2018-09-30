//
//  PlayVideoView.h
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AVFoundation/AVFoundation.h>
#import "AVVideoModel.h"
#import "PlayVideoCell.h"

@protocol AVPlayerDelegate <NSObject>
@optional
/** 视频加载成功，随时可以播放 */
- (void)av_playerLoadFinish;
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url;
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen;
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen;

@end

// 播放器的几种状态
typedef NS_ENUM(NSInteger, AVPlayerState) {
    AVPlayerStateFailed,     // 播放失败
    AVPlayerStateBuffering,  // 缓冲中
    AVPlayerStatePlaying,    // 播放中
    AVPlayerStateStopped,    // 停止播放
    AVPlayerStatePause       // 暂停播放
};

@interface AVPlayView : UIView

/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) AVPlayerState state;

/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL          isPauseByUser;

/** 当前播放层显示在哪个cell上 */
@property (nonatomic, strong) PlayVideoCell *playVideoCell;

@property (strong, nonatomic) AVPlayer *avPlayer;//播放器

@property (nonatomic, strong) AVVideoModel *avVideoModel;

- (void)changeCurrentplayerItemWithAV_VideoModel:(AVVideoModel *)avVideoModel;

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return AVPlayView
 */
+ (instancetype)sharedPlayerView;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

@end
