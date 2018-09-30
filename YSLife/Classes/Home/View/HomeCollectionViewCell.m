//
//  HomeCollectionViewCell.m
//  YSLife
//
//  Created by admin on 2018/6/5.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "GlobalDefines.h"

@interface HomeCollectionViewCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(19);
            make.width.mas_equalTo(39);
            make.height.mas_equalTo(39);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.imgView.mas_bottom).offset(8);
            make.height.mas_equalTo(13);
        }];
    }
    return self;
}

- (void)setAppListModel:(AppListModel *)appListModel
{
    _appListModel = appListModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:appListModel.appImage]];
    
    self.textLabel.text = appListModel.appName;
}

@end
