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
@end

@implementation AVPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //播放 暂停按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250, 600, 100, 100);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"按钮" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

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
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        // 计算缓冲进度
        /*
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = self.avPlayer.currentItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        NSLog(@"%f",timeInterval / totalDuration);
        */
    }
    //移除监听（观察者）
    //[object removeObserver:self forKeyPath:@"status"];
}

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
    NSURL *mediaURL = [NSURL URLWithString:avVideoModel.videoUrlString];
    //第二步：初始化一个播放单元
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:mediaURL];
    //第三步：初始化一个播放器对象
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    //第四步：初始化一个播放器的Layer
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayerLayer.frame = self.bounds;
    [self.layer addSublayer:self.avPlayerLayer];
    //第五步：开始播放
    //[self.avPlayer play];
    
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
            NSLog(@"currentTime:%zd---totalTime:%f---value:%f",currentTime,totalTime,value);
        }
    }];
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
