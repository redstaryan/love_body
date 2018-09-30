//
//  HXPhotoActionSheet.h
//  YSLife
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface HXPhotoActionSheet : UIView

@property (nonatomic, weak) UIViewController *fatherController;

/**
 （需先设置 sender 参数）

 @param photos 已选择的uiimage照片数组
 @param assets 已选择的phasset照片数组
 @param isOriginal 是否为原图
 */
@property (nonatomic, copy) void (^selectImageBlock)(NSArray<UIImage *> *__nullable images, NSArray<PHAsset *> *assets, BOOL isOriginal);

@end
