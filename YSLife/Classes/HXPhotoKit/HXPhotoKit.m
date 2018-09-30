//
//  HXPhotoKit.m
//  YSLife
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXPhotoKit.h"
#import <Photos/Photos.h>

@implementation HXPhotoKit

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        // 列出所有用户创建的相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        
        
    }
    return self;
}

@end
