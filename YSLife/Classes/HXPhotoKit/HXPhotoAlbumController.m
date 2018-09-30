//
//  HXPhotoAlbumController.m
//  YSLife
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 redstar. All rights reserved.
//

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define KHeight_TabBar (kDevice_Is_iPhoneX ? 34.f : 0.f)

#import "HXPhotoAlbumController.h"
#import <Photos/Photos.h>
#import "HXPhotoAlbumCell.h"

@interface HXPhotoAlbumController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)PHFetchResult *allPhotos;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HXPhotoAlbumController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏背景色
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) alphe:0.7];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    //title颜色
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //导航栏右边按钮
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButtonItem.frame = CGRectMake(0, 0, 66, 44);
    rightBarButtonItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBarButtonItem setTitle:@"取消" forState:UIControlStateNormal];
    [rightBarButtonItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBarButtonItem addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"照片";
    
    //拍摄 从手机相册选择 取消
    CGFloat tableViewY = 64 + KHeight_TabBar;
    CGFloat tableViewH = self.view.frame.size.height - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.frame.size.width, tableViewH) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [UIView new];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.view addSubview:tableView];
    self.tableView  = tableView;
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    /*
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    for (int i=0; i<smartAlbums.count; i++) {
        PHAssetCollection *assetCollection = smartAlbums[i];
        
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        NSLog(@"%@",assetCollection.localizedTitle);
    }
    NSLog(@"%@",smartAlbums.firstObject);
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSLog(@"aaa");
     */
}

- (void)rightBarButtonItemClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HXPhotoAlbumControllerCell";
    HXPhotoAlbumCell *cell = [[HXPhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (cell == nil) {
        cell = [[HXPhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:self.allPhotos.lastObject targetSize:CGSizeMake(56, 56) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imgView.image = result;
        }];
        cell.txtLabel.text = @"相机胶卷";
        
    } else if(indexPath.section == 1){
        cell.textLabel.text = @"取消";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alphe];
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
