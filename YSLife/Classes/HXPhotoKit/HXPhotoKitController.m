//
//  HXPhotoKitController.m
//  YSLife
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 redstar. All rights reserved.
//

#define KGapValue 5

#import "HXPhotoKitController.h"
#import "HXPhotoKitCell.h"
#import "HXPhoto.h"
#import <Photos/Photos.h>

@interface HXPhotoKitController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
//@property (nonatomic, strong) NSMutableArray *hxPhotoArray;
@property (nonatomic, assign)  CGSize thumbnailSize;
@property (nonatomic, assign) CGRect previousPreheatRect;
@end

@implementation HXPhotoKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    //导航栏右边按钮
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButtonItem.frame = CGRectMake(0, 0, 66, 44);
    rightBarButtonItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBarButtonItem setTitle:@"取消" forState:UIControlStateNormal];
    [rightBarButtonItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBarButtonItem addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem];
    
    //resetCachedAssets()
    //PHPhotoLibrary.shared().register(self)
    
    //导航栏背景色
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) alphe:0.7];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    //title颜色
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = self.flowLayout.itemSize;
    self.thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    //self.hxPhotoArray = [[NSMutableArray alloc] init];
    
    //self.imageManager = [[PHCachingImageManager alloc] init];

    [self resetCachedAssets];
    
    if (self.fetchResult == nil) {
        //获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        self.fetchResult = [PHAsset fetchAssetsWithOptions:options];
        NSLog(@"fetchResult:%ld",self.fetchResult.count);
    }
}

- (void)rightBarButtonItemClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = self.fetchResult[indexPath.row];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        NSLog(@"PHAssetMediaTypeVideo:%ld",indexPath.row);
    }
    
    HXPhotoKitCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXPhotoKitCell" forIndexPath:indexPath];
    
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([cell.representedAssetIdentifier isEqualToString: asset.localIdentifier]){
            HXPhoto *hxPhoto = [[HXPhoto alloc] init];
            hxPhoto.thumbnailImage = result;
            cell.hxPhoto = hxPhoto;
        }
    }];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //[cell setBackgroundColor:[RSColor colorWithHexString:@"#cccccc"]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(KGapValue, KGapValue, KGapValue, KGapValue);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets{
    BOOL isViewVisible = [self isViewLoaded] && self.view.window != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0, -0.5 * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0) {
        // Compute the assets to start caching and to stop caching
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self apple_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        } removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self apple_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.thumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:self.thumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect addedHandler:(void (^)(CGRect addedRect))addedHandler removedHandler:(void (^)(CGRect removedRect))removedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)apple_indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < self.fetchResult.count && indexPath.item != 0) {
            PHAsset *asset = self.fetchResult[self.fetchResult.count-indexPath.item];
            [assets addObject:asset];
        }
    }
    return assets;
}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat itemWH = (SCREEN_WIDTH - 5 * KGapValue) / 4;
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置布局方向为垂直流布局
        self.flowLayout.minimumLineSpacing = 0;
        self.flowLayout.minimumInteritemSpacing = 0;
        //flowLayout.headerReferenceSize = CGSizeMake(KScreenWidth, 49.0f);  //设置headerView大小
        //flowLayout.footerReferenceSize = CGSizeMake(KScreenWidth, 24.0f);  // 设置footerView大小
        
        //创建collectionView 通过一个布局策略layout来创建
        CGFloat collectionViewY = 0;
        CGFloat collectionViewH = SCREEN_HEIGHT;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  collectionViewY, SCREEN_WIDTH, collectionViewH) collectionViewLayout:self.flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        
        //注册item类型 这里使用系统的类型
        [collectionView registerClass:[HXPhotoKitCell class] forCellWithReuseIdentifier:@"HXPhotoKitCell"];
        
        self.collectionView = collectionView;
    }
    return _collectionView;
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
