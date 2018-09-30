//
//  PalyVideoViewController.m
//  YSLife
//
//  Created by admin on 2018/5/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#define SCREEN_WIDTH 375
#define SCREEN_HEIGHT 667
#define IMAGEVIEW_COUNT 3

#import "PalyVideoViewController.h"
#import<AVFoundation/AVFoundation.h>
#import "AVPlayView.h"
#import "PlayVideoCell.h"
#import "ZFPlayer.h"
#import "ZFPlayerCell.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"

@interface PalyVideoViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property (nonatomic, strong) NSMutableArray *videoModelArray;

@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) AVPlayView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation PalyVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentIndex = -1;
    
    //https://d2.xia12345.com/down/93/2018/05/H7Rbp23Y.mp4
    //https://d2.xia12345.com/down/93/2018/05/d4HEc7DF.mp4
    //https://d2.xia12345.com/down/93/2018/05/pWvQVFxv.mp4
    self.videoModelArray = [[NSMutableArray alloc] init];

    [self.view addSubview:self.tableView];
    
    [self loadHealthVideos];
}

/**
 * 获取视频
 */
- (void)loadHealthVideos
{
    NSString *urlStr = [NSString stringWithFormat:@"%@homeService/findVideoUrls",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"videoType":@"100001"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
        
        NSArray *dataArray = object[@"data"];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dict = dataArray[i];
            AVVideoModel *avVideoModel = [AVVideoModel mj_objectWithKeyValues:dict];
            [mutableArray addObject:avVideoModel];
        }
        
        [self.videoModelArray addObjectsFromArray:mutableArray];
        
        [self.tableView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayVideoCellIdentifier"];
    if (cell == nil) {
        cell = [[PlayVideoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlayVideoCellIdentifier"];
    }
    
     cell.avVideoModel = self.videoModelArray[indexPath.row];
    
    if (self.currentIndex == -1) {
        [cell.playVideoView addSubview:self.playerView];
        self.playerView.avVideoModel = self.videoModelArray[indexPath.row];
        self.playerView.playVideoCell = cell;
        self.currentIndex = 0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath---%zd",indexPath.row);
    //[self.playerView play];
    //PlayVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenHeight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.y / KScreenHeight;
    
    if (self.currentIndex != index && self.videoModelArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: index inSection:0];
        PlayVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell.playVideoView addSubview:self.playerView];
        self.playerView.avVideoModel = self.videoModelArray[indexPath.row];
        self.playerView.playVideoCell = cell;
        self.currentIndex = index;
    }
}

- (AVPlayView *)playerView {
    if (!_playerView) {
        _playerView = [AVPlayView sharedPlayerView];
        _playerView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        //_playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        //_playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.playerView removeFromSuperview];
}

@end
