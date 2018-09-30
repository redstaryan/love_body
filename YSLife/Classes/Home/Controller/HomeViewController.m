//
//  HomeViewController.m
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SDCycleScrollView.h"
#import "PalyVideoViewController.h"
#import "PlayMusicViewController.h"
#import "HomeCollectionViewCell.h"
#import "AppListModel.h"
#import "HomeHeaderView.h"
#import "HomeFooterView.h"

#import "HXPhotoKitView.h"
#import "HXPhotoKitController.h"
#import "HXPhotoActionSheet.h"


#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface HomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AMapGeoFenceManagerDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

static NSString *headerViewIdentifier = @"hederview";
static NSString *footerViewIdentifier = @"footerView";

@implementation HomeViewController

- (void)login
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/login.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"username":@"admin",
                              @"password":@"admin"};
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)set_category_name
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/category/set_category_name.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"categoryId":@"10000004",
                              @"categoryName":@"admin1",
                              @"token":@"33c0708a39ef47b2bcd657dee0b7229a"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)get_category
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/category/get_category.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"categoryId":@"100001",
                              @"token":@"33c0708a39ef47b2bcd657dee0b7229a"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)get_deep_category
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/category/get_deep_category.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"categoryId":@"100001",
                              @"token":@"33c0708a39ef47b2bcd657dee0b7229a"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)manageList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/product/list.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"pageNum":@"1",
                              @"pageSize":@"10",
                              @"token":@"3439a0c799f243bcb97087c1c103bd18"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)manageSearch
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/product/search.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"productName":@"美的",
                              @"productId":@"",//27
                              @"pageNum":@"1",
                              @"pageSize":@"10",
                              @"token":@"3439a0c799f243bcb97087c1c103bd18"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)manageDetail
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/product/detail.do",KYSBaseURL];
    NSDictionary *dataDic = @{@"productId":@"27",//27
                              @"token":@"34e27e34041343b7b1b52d059f527ff6"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}

- (void)set_sale_status
{
    NSString *urlStr = [NSString stringWithFormat:@"%@manage/product/set_sale_status.do",KYSBaseURL];
//    NSDictionary *dataDic = @{@"productId":@"27",//27
//                              @"status":@"2",
//                              @"token":@"34e27e34041343b7b1b52d059f527ff6"};
    
    NSDictionary *dataDic = @{@"productId":@"27"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initChildView];
    
    //[self login];
    
    //[self set_category_name];
    
    //[self get_category];
    
   // [self get_deep_category];
    
    //[self manageList];
    
    //[self manageSearch];
    
    //[self manageDetail];
    
    [self set_sale_status];
    
    //3.模块列表
    //[self.view addSubview:self.collectionView];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    //_imagesURLStrings = imagesURLStrings;
    
    // 情景三：图片配文字
    NSArray *titles = @[@"新建交流QQ群：185534916新建交流QQ群：185534916 ",
                        @"disableScrollGesture可以设置禁止拖动",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    
    self.cycleScrollView.titlesGroup = titles;
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    });

    /*
    //3.养生秘诀（脱发，减肥，美容，失眠）
    //4.婴儿养生
     */
    
    [self findAppList];
    
    //HXPhotoKitController *photoKitController = [[HXPhotoKitController alloc] init];
    //[self presentViewController:photoKitController animated:YES completion:^{
    //}];
//    HXPhotoKitView *hxPhotoKitView = [[HXPhotoKitView alloc] init];
//    hxPhotoKitView.backgroundColor = [UIColor blueColor];
//    hxPhotoKitView.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:hxPhotoKitView];
    
    HXPhotoActionSheet *actionSheet = [[HXPhotoActionSheet alloc] init];
    //actionSheet.sender = self;
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> *assets, BOOL isOriginal) {
        
    }];
    
    
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
    //self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
    
    //left top
    //{lat:31.158548; lon:121.187254; accuracy:5.000000}
    //{lat:31.158541; lon:121.187252; accuracy:5.000000}
    //{lat:31.158541; lon:121.187252; accuracy:5.000000}
    //{lat:31.158541; lon:121.187252; accuracy:5.000000}
    //{lat:31.158541; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    //{lat:31.158540; lon:121.187252; accuracy:5.000000}
    
    //left down
    //{lat:31.158368; lon:121.186321; accuracy:5.000000}
    //{lat:31.158365; lon:121.186328; accuracy:5.000000}
    //{lat:31.158365; lon:121.186328; accuracy:5.000000}
    //{lat:31.158365; lon:121.186327; accuracy:5.000000}
    //{lat:31.158365; lon:121.186327; accuracy:5.000000}
    //{lat:31.158364; lon:121.186327; accuracy:5.000000}
    //{lat:31.158364; lon:121.186327; accuracy:5.000000}
    //{lat:31.158364; lon:121.186327; accuracy:5.000000}
    //{lat:31.158364; lon:121.186326; accuracy:5.000000}
    //{lat:31.158364; lon:121.186326; accuracy:5.000000}
    //{lat:31.158364; lon:121.186326; accuracy:5.000000}
    
    //扩展距离
    //{lat:31.158362; lon:121.186328; accuracy:1414.000000}
    //{lat:31.158362; lon:121.186329; accuracy:5.000000}
    //{lat:31.158362; lon:121.186329; accuracy:5.000000}
    //{lat:31.158363; lon:121.186329; accuracy:5.000000}
    //{lat:31.158405; lon:121.186373; accuracy:5.000000}
    //{lat:31.158445; lon:121.186410; accuracy:5.000000}
    //{lat:31.158454; lon:121.186415; accuracy:5.000000}
    //{lat:31.158455; lon:121.186415; accuracy:5.000000}
    //{lat:31.158456; lon:121.186414; accuracy:5.000000}
    //{lat:31.158458; lon:121.186414; accuracy:5.000000}
    //{lat:31.158472; lon:121.186416; accuracy:5.000000}
    
    //right top
    //{lat:31.157922; lon:121.187053; accuracy:10.000000}
    //{lat:31.157926; lon:121.187054; accuracy:30.000000}
    //{lat:31.158034; lon:121.186898; accuracy:65.000000}
    //{lat:31.158000; lon:121.186904; accuracy:65.000000}
    //{lat:31.158000; lon:121.186904; accuracy:65.000000}
    //{lat:31.157956; lon:121.186754; accuracy:65.000000}
    //{lat:31.158016; lon:121.187416; accuracy:65.000000}
    //{lat:31.157996; lon:121.187204; accuracy:65.000000}
    
    //扩展距离
    //{lat:31.158076; lon:121.187419; accuracy:5.000000}
    //{lat:31.158076; lon:121.187411; accuracy:5.000000}
    //{lat:31.158069; lon:121.187411; accuracy:5.000000}
    //{lat:31.158066; lon:121.187430; accuracy:5.000000}
    
    //right down
    //{lat:31.158015; lon:121.186219; accuracy:5.000000}
    //{lat:31.158017; lon:121.186222; accuracy:10.000000}
    //{lat:31.158019; lon:121.186231; accuracy:5.000000}
    //{lat:31.158020; lon:121.186233; accuracy:5.000000}
    //{lat:31.158019; lon:121.186234; accuracy:5.000000}
    //{lat:31.158019; lon:121.186234; accuracy:10.000000}
    //{lat:31.158019; lon:121.186239; accuracy:5.000000}
    //{lat:31.158019; lon:121.186241; accuracy:5.000000}
    //{lat:31.158018; lon:121.186243; accuracy:5.000000}
    //{lat:31.158018; lon:121.186243; accuracy:5.000000}
    
    //remove
    //left down
    //{lat:31.157926; lon:121.186207; accuracy:10.000000}
    //{lat:31.157920; lon:121.186247; accuracy:10.000000}
    //{lat:31.157916; lon:121.186245; accuracy:10.000000}
    //{lat:31.157877; lon:121.186211; accuracy:5.000000}
    //{lat:31.157825; lon:121.186251; accuracy:5.000000}
    //{lat:31.157899; lon:121.186302; accuracy:5.000000}
    //{lat:31.157897; lon:121.186303; accuracy:5.000000}
    
    //right top
    //{lat:31.158211; lon:121.187543; accuracy:1414.000000}
    //{lat:31.157525; lon:121.187366; accuracy:5.000000}
    //{lat:31.157526; lon:121.187368; accuracy:5.000000}
    //{lat:31.157507; lon:121.187317; accuracy:5.000000}
    //{lat:31.157503; lon:121.187311; accuracy:5.000000}
    //{lat:31.157547; lon:121.187343; accuracy:5.000000}
    //{lat:31.157542; lon:121.187341; accuracy:5.000000}
    
    //right down
    //{lat:31.157521; lon:121.186551; accuracy:5.000000}
    //{lat:31.157549; lon:121.186571; accuracy:5.000000}
    //{lat:31.157566; lon:121.186571; accuracy:5.000000}
    //{lat:31.157638; lon:121.186627; accuracy:5.000000}
    //{lat:31.157672; lon:121.186606; accuracy:10.000000}
    
    NSInteger count = 4;
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    coorArr[0] = CLLocationCoordinate2DMake(31.157328, 121.185413);
    coorArr[1] = CLLocationCoordinate2DMake(31.157297, 121.185308);
    coorArr[2] = CLLocationCoordinate2DMake(31.157333, 121.185223);
    coorArr[3] = CLLocationCoordinate2DMake(31.157340, 121.185263);
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:@"polygon_1"];
    
    free(coorArr);
    coorArr = NULL;

    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 200;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location1111:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                       message: [NSString stringWithFormat:@"location:{lat:%f; lon:%f",location.coordinate.latitude,location.coordinate.longitude]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  NSLog(@"action = %@", action);
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"action = %@", action);
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
    }
}

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed success %@",[region description]);
        
       
    }
}

#pragma mark- 请求网络数据
- (void)findAppList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@homeService/findAppList",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"userId":@"100001"};
    
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        
        NSArray *dataArray = object[@"data"];
        
        //1.数据处理
        NSMutableArray *oldArray = [[NSMutableArray alloc] init];
        NSMutableArray *otherArray = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dict = dataArray[i];
            AppListModel *appListModel = [AppListModel mj_objectWithKeyValues:dict];
            
            if ([appListModel.appType isEqualToString:@"oldpeople"]) {
                
                [oldArray addObject:appListModel];
            } else {
                [otherArray addObject:appListModel];
            }
        }
        
        [self.dataArray addObject:oldArray];
        [self.dataArray addObject:otherArray];
        
        [self.collectionView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
        
    }];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCollection" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[HomeCollectionViewCell alloc] initWithFrame:CGRectMake(0,0, KScreenWidth / 4, 85)];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray *sectionArray = self.dataArray[indexPath.section];
    cell.appListModel = sectionArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = self.dataArray[indexPath.section];
    AppListModel *appListModel = sectionArray[indexPath.row];
    
    if ([appListModel.jumpType isEqualToString:@"app"]) {
        // 有参数
        SEL selector = NSSelectorFromString(appListModel.jumpUrl);
        if([self respondsToSelector:selector]){
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@在维护中",appListModel.jumpUrl];
            [hud hideAnimated:YES afterDelay:1];
        }
    }
}

//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[RSColor colorWithHexString:@"#cccccc"]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        HomeHeaderView *reusableHeaderView  = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            reusableHeaderView.titleLabel.text = @"老人服务";
        } else {
            reusableHeaderView.titleLabel.text = @"养生秘诀";
        }
        return reusableHeaderView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        HomeFooterView *reusableFooterView  = (HomeFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier forIndexPath:indexPath];
        return reusableFooterView;
    }
    return nil;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - 跳转
- (void)jumpPalyVideo
{
    PalyVideoViewController *palyVideoViewController = [[PalyVideoViewController  alloc] init];
    palyVideoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:palyVideoViewController animated:YES];
}

- (void)jumpPlayMusic
{
    PlayMusicViewController *playAudioViewController = [[PlayMusicViewController  alloc] init];
    playAudioViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playAudioViewController animated:YES];
}

#pragma mark- 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //恢复导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark- 初始化页面
- (void)initChildView
{
    //1.顶部模块
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, KHeight_topNav, KScreenWidth, 131);
    [self.view addSubview:headView];
    
    //1.1顶部模块-左边图标
    CGFloat imgWH = 102;
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.backgroundColor = [UIColor redColor];
    iconImgView.layer.cornerRadius = 8;
    iconImgView.layer.masksToBounds = YES;
    [headView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(KLRMarginValue);
        make.top.equalTo(headView).offset(9);
        make.width.mas_equalTo(imgWH);
        make.height.mas_equalTo(imgWH);
    }];
    
    //1.2顶部模块-右边推荐
    CGFloat cycleX = imgWH + KLRMarginValue + 8;
    CGFloat cycleY = 9;
    CGFloat cycleWidth = KScreenWidth - cycleX - KLRMarginValue;
    CGFloat cycleHeight = imgWH;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(cycleX, cycleY, cycleWidth, cycleHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.layer.cornerRadius = 5;
    cycleScrollView.layer.masksToBounds = YES;
    [headView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    //2.列表-UICollectionView
    CGFloat itemWidth = KScreenWidth / 4;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemWidth, 85);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置布局方向为垂直流布局
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(KScreenWidth, 49.0f);  //设置headerView大小
    flowLayout.footerReferenceSize = CGSizeMake(KScreenWidth, 24.0f);  // 设置footerView大小
    
    //创建collectionView 通过一个布局策略layout来创建
    CGFloat collectionViewY = headView.frame.origin.y + headView.frame.size.height;
    CGFloat collectionViewH = KScreenHeight - collectionViewY - self.tabBarController.tabBar.frame.size.height;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  collectionViewY, KScreenWidth, collectionViewH) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    
    //注册item类型 这里使用系统的类型
    [collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"homeCollection"];
    //注册header视图
    [collectionView registerClass:[HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    //注册footer视图
    [collectionView registerClass:[HomeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

@end
