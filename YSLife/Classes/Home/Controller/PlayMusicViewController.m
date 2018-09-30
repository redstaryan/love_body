//
//  PlayMusicViewController.m
//  YSLife
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#define KImageY (KHeight_topNav + 80)

#import "PlayMusicViewController.h"
#import<AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicModel.h"
#import "PlayMusicCell.h"
#import "HXAnimation.h"

@interface PlayMusicViewController ()<UITableViewDataSource,UITableViewDelegate,PlayMusicCellDelegate>
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) MusicModel *currentModel;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIImageView *playStatusImageView;
@property (nonatomic, weak) UIView *musicView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"助眠声音";
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initChildView];
    
    [self findtHealthMusic];
}

#pragma mark- 请求网络数据
- (void)findtHealthMusic
{
    NSString *urlStr = [NSString stringWithFormat:@"%@homeService/findtHealthMusics",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"musicType":@"sleep"};
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        
        NSArray *dataArray = object[@"data"];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dict = dataArray[i];
            MusicModel *musicModel = [MusicModel mj_objectWithKeyValues:dict];
            [mutableArray addObject:musicModel];
            
            if (i==0) {
                musicModel.isPlay = YES;
            }
        }
        
        [weakSelf.dataArray addObjectsFromArray: mutableArray];
        
        [weakSelf.tableView reloadData];
        
        if (self.dataArray.count > 0) {
            weakSelf.currentIndex = 0;
            [weakSelf refreshMusic:self.dataArray[0]];
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
        
    }];
}

- (void)refreshMusic:(MusicModel *)musicModel
{
    [self.playStatusImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.imgUrl] placeholderImage:nil];
    
    //替换当前音乐资源
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:musicModel.fileUrl]];
    if (self.avPlayer) {
        [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    } else {
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
        
        [self.avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        //当音乐播放完成，或者切换下一首歌曲时，请务必记得移除观察者，否则会crash。操作如下：
        //[self.avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
        
        //KVO监听音乐缓冲状态
        [self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    }
    
    self.playButton.selected = YES;
    [self.avPlayer play];//开始播放
    [HXAnimation rotateView:self.playStatusImageView];
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PlayMusicCellIdentifier";
    PlayMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PlayMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    
    cell.musicModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 390;
}

#pragma mark-点击事件
- (void)playButtonClick
{
    PlayMusicCell *playMusicCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    if (self.playButton.selected == NO) {
        self.playButton.selected = YES;
        [self.avPlayer play];//开始播放
        [playMusicCell play];
    } else {
        self.playButton.selected = NO;
        [self.avPlayer pause];//停止播放
        [playMusicCell pause];
    }
    
    //1.判断myView.layer上是否添加了动画
    CAAnimation *animation = [self.playStatusImageView.layer animationForKey:@"rotationAnimation"];
    if (animation) {
        
        //2.判断是否暂停、恢复
        if (self.playButton.selected == YES) {
            [HXAnimation resumeAnimation:self.playStatusImageView];//恢复动画
        } else {
            [HXAnimation pauseAnimation:self.playStatusImageView];//暂停动画
        }
        
    } else {
        [HXAnimation rotateView:self.playStatusImageView];
    }
}

- (void)moreMusicButtonClick
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin.y = KImageY;
    [UIView animateWithDuration:1 animations:^{
        self.tableView.frame = tableViewFrame;
    }];
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

//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{   //注意这里查看的是self.player.status属性
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.avPlayer.status) {
            case AVPlayerStatusUnknown:
            {
                 NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = self.avPlayer.currentItem.loadedTimeRanges;        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;        //更新缓冲进度条
        //self.loadTimeProgress.progress = scale;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin.y = KScreenHeight;
    [UIView animateWithDuration:1 animations:^{
        self.tableView.frame = tableViewFrame;
    }];
}

#pragma mark - PlayMusicCellDelegate
- (void)playButtonClick:(NSIndexPath *)indexPath isPlay:(BOOL)isPlay
{
    PlayMusicCell *playMusicCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if (indexPath.row == self.currentIndex) {
        if (isPlay == YES) {
            [playMusicCell play];
            
        } else {
            [playMusicCell pause];
        }
        
        self.playButton.selected = !isPlay;
        [self playButtonClick];
    } else {
        //先停止老的
        PlayMusicCell *oldPlayMusicCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        [oldPlayMusicCell pause];
        
        MusicModel *oldMusicModel = self.dataArray[self.currentIndex];
        oldMusicModel.isPlay = NO;
        [self.dataArray replaceObjectAtIndex:self.currentIndex withObject:oldMusicModel];
        
        //再开始新的
        [playMusicCell play];
        
        MusicModel *musicModel = self.dataArray[indexPath.row];
        musicModel.isPlay = isPlay;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:musicModel];
        
        self.currentIndex = indexPath.row;
        
        [self refreshMusic:musicModel];
    }
}

#pragma mark- 初始化页面
- (void)initChildView
{
    //音乐封面图
    CGFloat imgWH = KScreenWidth - 50;
    //CGFloat imgY = KHeight_topNav + 80;
    UIImageView *playStatusImageView = [[UIImageView alloc] init];
    playStatusImageView.layer.cornerRadius = imgWH / 2;
    playStatusImageView.layer.masksToBounds = YES;
    //playStatusImageView.image = [UIImage imageNamed:@"WechatIMG886"];
    [self.view addSubview:playStatusImageView];
    [playStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(KImageY);
        make.width.mas_equalTo(imgWH);
        make.height.mas_equalTo(imgWH);
    }];
    self.playStatusImageView = playStatusImageView;
    
    //播放按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateSelected];
    [self.view addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(playStatusImageView);
        make.centerY.equalTo(playStatusImageView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.playButton = playButton;
    
    
    //当音乐播放完成，或者切换下一首歌曲时，请务必记得移除观察者，否则会crash。操作如下：
    //[self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton *moreMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreMusicButton.backgroundColor = [UIColor redColor];
    [moreMusicButton addTarget:self action:@selector(moreMusicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreMusicButton];
    [moreMusicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playStatusImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    CGRect tableViewFrame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight - KImageY);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/*
//音乐锁屏信息展示
- (void)setupLockScreenInfo
{
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2、设置歌曲名
    if (self.currentModel.name) {
        [playingInfoDict setObject:self.currentModel.name forKey:MPMediaItemPropertyAlbumTitle];
    }
    // 设置歌手名
    if (self.currentModel.artist) {
        [playingInfoDict setObject:self.currentModel.artist forKey:MPMediaItemPropertyArtist];
    }
    // 3设置封面的图片
    UIImage *image = [self getMusicImageWithMusicId:self.currentModel];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    // 4设置歌曲的总时长
    [playingInfoDict setObject:self.currentModel.detailDuration forKey:MPMediaItemPropertyPlaybackDuration];
    
    //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 5.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//获取远程网络图片，如有缓存取缓存，没有缓存，远程加载并缓存
-(UIImage*)getMusicImageWithMusicId:(MusicModel*)model
{
    UIImage *image;
    NSString *key = [model.Id stringValue];
    UIImage *cacheImage = self.musicImageDic[key];
    if (cacheImage) {
        image = cacheImage;
    }else{
        //这里用了非常规的做法，仅用于demo快速测试，实际开发不推荐，会堵塞主线程
        //建议加载歌曲时先把网络图片请求下来再设置
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover]];
        image =  [UIImage imageWithData:data];
        if (image) {
            [self.musicImageDic setObject:image forKey:key];
            
        }
    }
    
    return image;
}
*/

@end
