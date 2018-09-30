//
//  PlayVideoCell.m
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "PlayVideoCell.h"
#import "AVPlayView.h"
#import "ZFPlayerControlView.h"
#import "ZFPlayerView.h"

@interface PlayVideoCell()

@property (nonatomic, weak) UIImageView *placeholderImageView;
@property (nonatomic, weak) UIImageView *playImgView;//播放按钮
//@property (nonatomic, weak) AVPlayView *playVideoView;
@property(nonatomic,retain) AliVcMediaPlayer *mediaPlayer;
@property (nonatomic, strong) ZFPlayerView *playerView;
@end

@implementation PlayVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor blackColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //AVPlayView *playVideoView = [[AVPlayView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth , KScreenHeight)];
//        AVPlayView *playerView = [AVPlayView sharedPlayerView];
//        playerView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//        [self.contentView addSubview:playerView];
//        self.playVideoView = playerView;
        
//        self.playerView = [[ZFPlayerView alloc] init];
//        [self.contentView addSubview:self.playerView];
//        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(20);
//            make.left.right.equalTo(self.contentView);
//            // Here a 16:9 aspect ratio, can customize the video aspect ratio
//            make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
//        }];
        
        self.playVideoView = [[UIView alloc] init];
        //self.playVideoView.backgroundColor = [UIColor black];
        [self.contentView addSubview:self.playVideoView];
        [self.playVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        UIImageView *placeholderImageView = [[UIImageView alloc] init];
        placeholderImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.center.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        self.placeholderImageView = placeholderImageView;
        
        UIImageView *playImgView = [[UIImageView alloc] init];
        playImgView.image = [UIImage imageNamed:@"video_list_cell_big_icon"];
        playImgView.hidden = YES;
        [self.contentView addSubview:playImgView];
        [playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        self.playImgView = playImgView;
    }
    return self;
}

- (void)setAvVideoModel:(AVVideoModel *)avVideoModel
{
    _avVideoModel = avVideoModel;
    
    self.placeholderImageView.alpha = 1;
    
    [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:avVideoModel.imageurl] placeholderImage:nil];
    
    [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:avVideoModel.imageurl] placeholderImage:[UIImage imageNamed:@"loading_bgView"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        CGFloat imgH = 0;
        CGSize imageSize = image.size;
        if (imageSize.height > 0) {
            //这里就把图片根据 固定的需求宽度  计算 出图片的自适应高度
            imgH = imageSize.height * KScreenWidth / imageSize.width;
        }
        [self.placeholderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imgH);
        }];
    }];
}

/**
 *  播放
 */
- (void)av_playerItemPlaying{
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
    self.playImgView.hidden = YES;
}

/**
 * 暂停
 */
- (void)pause {
    self.playImgView.hidden = NO;
}

- (void)playVideo
{
    //创建播放器
    self.mediaPlayer = [[AliVcMediaPlayer alloc] init];
    //创建播放器视图，其中contentView为UIView实例，自己根据业务需求创建一个视图即可
    /*self.mediaPlayer:NSObject类型，需要UIView来展示播放界面。
     self.contentView：承载mediaPlayer图像的UIView类。
     self.contentView = [[UIView alloc] init];
     [self.view addSubview:self.contentView];
     */
    //[self.mediaPlayer create:self.contentView];
    [self.mediaPlayer create:self];
    //设置播放类型，0为点播、1为直播，默认使用自动
    self.mediaPlayer.mediaType = MediaType_AUTO;
    //设置超时时间，单位为毫秒
    self.mediaPlayer.timeout = 25000;
    //缓冲区超过设置值时开始丢帧，单位为毫秒。直播时设置，点播设置无效。范围：500～100000
    self.mediaPlayer.dropBufferDuration = 8000;
    
    /*
     //一、播放器初始化视频文件完成通知，调用prepareToPlay函数，会发送该通知，代表视频文件已经准备完成，此时可以在这个通知中获取到视频的相关信息，如视频分辨率，视频时长等
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnVideoPrepared:)
     name:AliVcMediaPlayerLoadDidPreparedNotification object:self.mediaPlayer];
     //二、播放完成通知。视频正常播放完成时触发。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnVideoFinish:)
     name:AliVcMediaPlayerPlaybackDidFinishNotification object:self.mediaPlayer];
     //三、播放器播放失败发送该通知，并在该通知中可以获取到错误码。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnVideoError:)
     name:AliVcMediaPlayerPlaybackErrorNotification object:self.mediaPlayer];
     //四、播放器Seek完成后发送该通知。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnSeekDone:)
     name:AliVcMediaPlayerSeekingDidFinishNotification object:self.mediaPlayer];
     //五、播放器开始缓冲视频时发送该通知，当播放网络文件时，网络状态不佳或者调用seekTo时，此通知告诉用户网络下载数据已经开始缓冲。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnStartCache:)
     name:AliVcMediaPlayerStartCachingNotification object:self.mediaPlayer];
     //六、播放器结束缓冲视频时发送该通知，当数据已经缓冲完，告诉用户已经缓冲结束，来更新相关UI显示。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(OnEndCache:)
     name:AliVcMediaPlayerEndCachingNotification object:self.mediaPlayer];
     //七、播放器主动调用Stop功能时触发。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(onVideoStop:)
     name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
     //八、播放器状态首帧显示后发送的通知。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(onVideoFirstFrame:)
     name:AliVcMediaPlayerFirstFrameNotification object:self.mediaPlayer];
     //九、播放器开启循环播放功能，开始循环播放时发送的通知。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(onCircleStart:)
     name:AliVcMediaPlayerCircleStartNotification object:self.mediaPlayer];
     //十、直播答题接收的SEI数据消息，收到SEI通知后就可以展示SEI对应的题目了。
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(onSeiData:)
     name:AliVcMediaPlayerSeiDataNotification object:self.mediaPlayer];
     */
    //本地视频,填写文件路径
    // NSURL *url = [NSURL fileURLWithPath:@""];
    //网络视频，填写网络url地址
    NSURL *url = [NSURL URLWithString:@"http://ohjdda8lm.bkt.clouddn.com/course/sample1.mp4"];
    //prepareToPlay:此方法传入的参数是NSURL类型.
    AliVcMovieErrorCode err = [self.mediaPlayer prepareToPlay:url];
    
    //开始播放
    [self.mediaPlayer play];
    /*
     //停止播放
     [self.mediaPlayer stop];
     //暂停播放
     [self.mediaPlayer pause];
     //恢复播放，在暂停后再调用play接口即为恢复播放
     [self.mediaPlayer play];
     //重播
     //1.首先停止本次播放
     [self.mediaPlayer stop];
     //2.重新prepareToPlay
     AliVcMovieErrorCode err = [self.mediaPlayer prepareToPlay:url];
     //3.重新播放
     [self.mediaPlayer play];
     //Seek，跳转到指定时间点的视频画面，时间单位为毫秒
     [self.mediaPlayer seekTo:25000];
     */
    
    /*
     //获取播放的当前时间，单位为毫秒
     NSTimeInterval currentTime = self.mediaPlayer.currentPosition
     //获取视频的总时长，单位为毫秒
     NSTimeInterval duration = self.mediaPlayer.duration
     //计算当前进度，可以把当前进度值设置给进度条在界面上显示
     float progress = currentTime/duration
     */
    
    //倍数播放支持0.5~2倍的设置，支持音频变速不变调。
    /*
     *playSpeed:范围0.5～2；playSpeed=1时，为正常播放速度；playSpeed<1时，慢速播放；playSpeed>1时，加速播放。
     */
    self.mediaPlayer.playSpeed = 1.5;
    
    self.mediaPlayer.circlePlay = YES;//循环播放控制
    
    //截取当前正在播放图像
    UIImage*image = [self.mediaPlayer snapshot];
    
    /*
     //渲染视图角度
     [self.aliPlayer setRenderRotate:renderRotate0];
     
     //渲染镜像
     [self.aliPlayer setRenderMirrorMode:renderMirrorModeNone];
     
     //设置播放器音量（系统音量），值为0~1.0
     [self.mediaPlayer setVolume:0.8];
     //设置为静音
     [self.mediaPlayer setMuteMode:YES];
     //设置亮度（系统亮度），值为0~1.0
     [self.mediaPlayer setBrightness:0.5];
     //设置显示模式，可设置为fit方式填充或corp方式裁剪充满
     [self.mediaPlayer setScalingMode:scalingModeAspectFit];
     
     [self.mediaPlayer setReferer:@""];
     */
}

@end
