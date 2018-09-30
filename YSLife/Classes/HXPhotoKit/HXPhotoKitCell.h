//
//  HXPhotoKitCell.h
//  YSLife
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhoto.h"

@interface HXPhotoKitCell : UICollectionViewCell
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, strong) HXPhoto *hxPhoto;
@end
