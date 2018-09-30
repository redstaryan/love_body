//
//  HXPhotoKitCell.m
//  YSLife
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 redstar. All rights reserved.
//

//自定义图片名称存于plist中的key
#define ZLCustomImageNames @"ZLCustomImageNames"

// 图片路径
#define kZLPhotoBrowserSrcName(file) [@"HXPhotoKit.bundle" stringByAppendingPathComponent:file]
#define kZLPhotoBrowserFrameworkSrcName(file) [@"Frameworks/ZLPhotoBrowser.framework/HXPhotoKit.bundle" stringByAppendingPathComponent:file]

#import "HXPhotoKitCell.h"

@interface HXPhotoKitCell()
@property (nonatomic, weak) UIImageView *thumbnailImage;
@property (nonatomic, weak) UIButton *selectButton;
@end

@implementation HXPhotoKitCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *thumbnailImage = [[UIImageView alloc] init];
        thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
        thumbnailImage.clipsToBounds = YES;
        thumbnailImage.frame = self.contentView.bounds;
        [self.contentView addSubview:thumbnailImage];
        self.thumbnailImage = thumbnailImage;
        
        CGFloat selectButtonWH = 30;
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(self.contentView.bounds.size.width - selectButtonWH, 0, selectButtonWH, selectButtonWH);
        [selectButton setImage:GetImageWithName(@"btn_unselected") forState:UIControlStateNormal];
        [self.contentView addSubview:selectButton];
    }
    return self;
}

- (void)setHxPhoto:(HXPhoto *)hxPhoto
{
    _hxPhoto = hxPhoto;
    
    self.thumbnailImage.image = _hxPhoto.thumbnailImage;
}

static inline UIImage * GetImageWithName(NSString *name) {
    NSArray *names = [[NSUserDefaults standardUserDefaults] valueForKey:ZLCustomImageNames];
    if ([names containsObject:name]) {
        return [UIImage imageNamed:name];
    }
    return [UIImage imageNamed:kZLPhotoBrowserSrcName(name)]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(name)];
}

@end
