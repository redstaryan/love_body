//
//  HXPhotoAlbumCell.m
//  YSLife
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXPhotoAlbumCell.h"

@implementation HXPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.frame = CGRectMake(0, 0, 56, 56);
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        [self.contentView addSubview:self.imgView];
        
        self.txtLabel = [[UILabel alloc] init];
        self.txtLabel.frame = CGRectMake(65, 0, 200, 56);
        [self.contentView addSubview:self.txtLabel];
    }
    return self;
}

@end
