//
//  TodayViewController.m
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayTableViewCell.h"
#import "TodayModel.h"
#import "TodayCardView.h"

#import "HXStepsManger.h"
#import <CoreMotion/CoreMotion.h>

@interface TodayViewController ()<UITableViewDataSource,UITableViewDelegate,TodayTableViewCellDelegate,TodayCardViewDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSArray<PHAsset *> *lastSelectAssets;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CMPedometer *pedometer;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    //步数View
    
    [[HXStepsManger sharedStepsManger] queryPedometerSteps:^(CMPedometerData * _Nullable pedometerData) {
        NSLog(@"我已经走了%@步",pedometerData.numberOfSteps);
        NSLog(@"距离%@米",pedometerData.distance);
    }];
    
    self.view.backgroundColor = [RSColor colorWithHexString:@"#f6f7fb"];
    /*
    1.没有那个她他，但是你有我在，我关心你的一切，吃饭，睡觉，生活
     
    2.你永远无法预测，意外和明天哪个来的更早，
    我们要做的就是尽最大的努力过好今天
     
     3.人生只有三天，活在昨天的人迷惑；活在明天的人等待；活在今天的人最踏实。
     你永远无法预测意外和明天哪个来得更早，所以，我们能做的，就是尽最大的努力过好今天。
     请记住：今天永远是昨天死去的人所期待的明天。
     */
    
    //[[HXStepsManger sharedStepsManger] init];
    
    //1.生命一刻
    //2.健康每秒
    //2.健康一步
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSArray *desArray = @[@"早餐自己做的，心情美美哒",
                          @"午餐叫的外卖,外卖小哥哥好帅",
                          @"晚餐是小胖请我吃的",
                          @"今天在朋友家睡的,开始入睡"];
    
    NSArray *titleArray = @[@"早餐:最佳时段 7:00~8:30",
                            @"午餐:最佳时段 12:00~13:30",
                            @"晚餐:最佳时段 18:30~20:00",
                            @"睡觉:最佳时段 21:30~23:00"];
    for (int i=0; i<4; i++) {
        TodayModel *todayModel = [[TodayModel alloc] init];
        todayModel.title = titleArray[i];
        todayModel.content = desArray[i];
        [self.dataArray addObject:todayModel];
    }
    
    //[self initChildView];
    
    [self loadTodayData];
    
}

- (void)loadTodayData
{
    NSString *urlString = @"userTodayService/findUserToday";
    NSDictionary *dataDic = @{@"userid":@"7",
                              @"datetime":@""};
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSInteger success = [object[@"success"] integerValue];
        NSString *message = object[@"message"];
        weakSelf.dataArray = object[@"data"];
        [weakSelf initCardView];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"aaaaa");
    } progress:^(float progress) {
        NSLog(@"aaaaa");
    }];
}

- (void)initCardView
{
    for (int i = 0; i<4-self.dataArray.count; i++) {
        TodayCardView *cardView = [[TodayCardView alloc] init];
        cardView.delegate = self;
        cardView.todayType = 4-i;
        cardView.fatherViewController = self;
        cardView.frame = CGRectMake(KLRMarginValue, KHeight_topNav + KLRMarginValue, KScreenWidth -  2 * KLRMarginValue, 250);
        [self.view addSubview:cardView];
    }
}

#pragma mark-initChildView
- (void)initChildView
{
    //今天的日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];

    UILabel *timeLabel = [[UILabel alloc]  init];
    timeLabel.frame = CGRectMake(KLRMarginValue, KHeight_topNav + KLRMarginValue, KScreenWidth - 2 *KLRMarginValue, 30);
    timeLabel.text = [formatter stringFromDate:datenow];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [RSColor colorWithHexString:@"#666666"];
    [self.view addSubview:timeLabel];
    CGFloat timeLabelBottomY = timeLabel.frame.origin.y + timeLabel.frame.size.height;
    
    CGFloat tableViewH = KScreenHeight - timeLabelBottomY - 20 - self.tabBarController.tabBar.frame.size.height;
    CGRect tableViewFrame = CGRectMake(0, timeLabelBottomY + 20, KScreenWidth, tableViewH);
    UITableView *tableView = [[UITableView alloc]  initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新时候，需要执行的代码。一般是请求最新数据，请求成功之后，刷新列表
        [weakSelf loadTodayData];
    }];
    
    //1.最佳上午加餐时间段：10:30以后
    //2.最佳下午加餐时间段 15:30左右
    //3.最佳晚上加餐时间段 21:00左右
    //4.夏季 22:00~23:00 -> 入睡 6:00~7:00 -> 起床
    //4.冬季 21:30~22:30 -> 入睡 6:30~7:30 -> 起床
    /*
     @"早餐最佳时间段 7：00~8：30 ",
     @"午餐最佳时间段 12：00~13：30",
     @"晚餐最佳时间段 18：30~20：00",
     @"睡觉最佳时间段21：30~23：00"
     */
}

#pragma mark-  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayTableViewCell"];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodayTableViewCell"];
    }
    
    TodayModel *todayModel = self.dataArray[indexPath.row];
    
    cell.indexPath = indexPath;
    
    cell.todayModel = todayModel;
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}

#pragma mark-TodayTableViewCellDelegate
-(void)clickCameraButton
{
    [self.view endEditing:YES];
    
   // TodayModel *todayModel = self.dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    //self.actionSheet.arrSelectedAssets = (NSMutableArray *)todayModel.lastSelectAssets;
    [self.actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        weakSelf.lastSelectAssets = assets;
        weakSelf.lastSelectPhotos = images;
        
        //[weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:todayModel];
        
        //[weakSelf.tableView reloadData];
    }];
    
    //调用相册
    [self.actionSheet showPhotoLibrary];
}

-(void)didClickSendButton:(NSIndexPath *)indexPath;
{
    TodayModel *todayModel = self.dataArray[indexPath.row];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@userTodayService/addUserToday",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"userid":@"7",
                              @"content":@"aaaa",
                              @"type":@"3"};
    
    [NetWorkManager uploadImageWithOperations:dataDic withImageArray:todayModel.lastSelectPhotos withtargetWidth:0 withUrlString:urlStr withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailurBlock:^(NSError *error) {
        NSLog(@"error");
    } withUpLoadProgress:^(float progress) {
        NSLog(@"progress");
    }];
}

- (void)didClickButton:(BOOL)isEat
{
    
}

#pragma mark-click
//获取当前的时间
-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end
