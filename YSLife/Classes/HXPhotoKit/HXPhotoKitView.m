//
//  HXPhotoKitView.m
//  YSLife
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXPhotoKitView.h"
#import <Photos/Photos.h>

@implementation HXPhotoKitView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        
        // 在资源的集合中获取第一个集合，并获取其中的图片
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHAsset *asset = assetsFetchResults.lastObject;
        [imageManager requestImageForAsset:asset
                                targetSize:PHImageManagerMaximumSize
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 // 得到一张 UIImage，展示到界面上
                                 
                                 UIImageView *imgVew = [[UIImageView alloc] init];
                                 imgVew.frame = self.bounds;
                                 imgVew.backgroundColor = [UIColor redColor];
                                 imgVew.image = result;
                                 [self addSubview:imgVew];
                             }];
    }
    return self;
}

@end
