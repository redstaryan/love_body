//
//  PlayVideoView.m
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "AVPlayView.h"

@interface AVPlayView()
@property (strong, nonatomic) AVPlayerItem *avPlayerItem;//播放单元
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;//播放界面（layer）
@property (assign, nonatomic) BOOL isReadToPlay;//用来判断当前视频是否准备好播放。
@property (nonatomic, strong) id                     timeObserve;

/** 播发器的几种状态 */
@property (nonatomic, assign) AVPlayerState          state;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
@end

@implementation AVPlayView

#pragma mark - Public Method
/**
 *  单例，用于列表cell上多个视频
 *
 *  @return AVPlayView
 */
+ (instancetype)sharedPlayerView {
    static AVPlayView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[AVPlayView alloc] init];
    });
    return playerView;
}

/**
 *  代码初始化调用此方法
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        //[self initializeThePlayer];
    }
    return self;
}

- (void)setPlayVideoCell:(PlayVideoCell *)playVideoCell
{
    _playVideoCell = playVideoCell;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误:%@",self.avPlayer.error.description);
                //self.isReadToPlay = NO;
                self.state = AVPlayerStateFailed;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.state = AVPlayerStatePlaying;
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        // 计算缓冲进度
        /*
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = self.avPlayer.currentItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        NSLog(@"%f",timeInterval / totalDuration);
        */
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        // 当缓冲是空的时候
        if (self.avPlayer.currentItem.playbackBufferEmpty) {
            self.state = AVPlayerStateBuffering;
            [self bufferingSomeSecond];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        // 当缓冲好的时候
        if (self.avPlayer.currentItem.playbackLikelyToKeepUp && self.state == AVPlayerStateBuffering){
            self.state = AVPlayerStatePlaying;
        }
    }
    //移除监听（观察者）
    //[object removeObserver:self forKeyPath:@"status"];
}

#pragma mark - Public Method

- (void)playAction
{
    if ( self.isReadToPlay) {
        if (self.avPlayer.rate == 1) {
            [self.avPlayer pause];
        } else {
            [self.avPlayer play];
        }
    }else{
        NSLog(@"视频正在加载中");
    }
}

/**
 *  播放
 */
- (void)play {
    if (self.state == AVPlayerStatePause) {
        self.state = AVPlayerStatePlaying;
    }
    self.isPauseByUser = NO;
    [self.avPlayer play];
}

/**
 * 暂停
 */
- (void)pause {
    if (self.state == AVPlayerStatePlaying) {
        self.state = AVPlayerStatePause;
    }
    self.isPauseByUser = YES;
    [self.avPlayer pause];
}

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(AVPlayerState)state {
    _state = state;
    
    if (state == AVPlayerStatePlaying || state == AVPlayerStateBuffering) {
        // 隐藏占位图
        [self.playVideoCell av_playerItemPlaying];
    } else if (state == AVPlayerStateFailed) {
        //NSError *error = [self.playerItem error];
        //[self.controlView zf_playerItemStatusFailed:error];
    }
}

/**
 *  添加播放器通知
 */
-(void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification
{
    NSLog(@"视频播放完成.");
    //跳到最新的时间点开始播放 播放完成后重复播放
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer play];
}

- (void)setAvVideoModel:(AVVideoModel *)avVideoModel
{
    _avVideoModel = avVideoModel;
    
    [self changeCurrentplayerItemWithAV_VideoModel:avVideoModel];
}

- (void)changeCurrentplayerItemWithAV_VideoModel:(AVVideoModel *)avVideoModel
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.avPlayerLayer removeFromSuperlayer];
    [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    [self.avPlayer pause];
    
    // 移除time观察者
    if (self.timeObserve) {
        [self.avPlayer removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }

    //第一步：首先我们需要一个播放的网址
    NSURL *mediaURL = [NSURL URLWithString:avVideoModel.videourl];
    //第二步：初始化一个播放单元
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:mediaURL];
    //第三步：初始化一个播放器对象
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    //[self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];//有些文章说该方法阻塞线程
    //第四步：初始化一个播放器的Layer
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayerLayer.frame = self.bounds;
    [self.layer addSublayer:self.avPlayerLayer];
    //第五步：开始播放
    [self play];
    
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    //监听播放的时间
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.avPlayer.currentItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            //[weakSelf.controlView zf_playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
            //NSLog(@"currentTime:%zd---totalTime:%f---value:%f",currentTime,totalTime,value);
        }
    }];
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.state = AVPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.avPlayer pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.avPlayer.currentItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}


#pragma mark - 计算缓冲进度
/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)dealloc
{
    [self removeNotification];
}

@end
