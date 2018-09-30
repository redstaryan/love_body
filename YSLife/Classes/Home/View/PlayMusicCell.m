//
//  PlayMusicCell.m
//  YSLife
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "PlayMusicCell.h"
#import "HXAnimation.h"

@interface PlayMusicCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *desLabel;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UIButton *playButton;
@end

@implementation PlayMusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] init];
        backView.layer.cornerRadius = 15;
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(KLRMarginValue);
            make.right.equalTo(self.contentView).offset(-KLRMarginValue);
            make.top.equalTo(self.contentView).offset(KLRMarginValue);
            make.bottom.equalTo(self.contentView).offset(-KLRMarginValue);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(KLRMarginValue);
            make.right.equalTo(backView).offset(-KLRMarginValue);
            make.top.equalTo(backView).offset(20);
            make.height.mas_equalTo(17);
        }];
        self.titleLabel = titleLabel;
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.textColor = [RSColor colorWithHexString:@"#999999"];
        desLabel.font = [UIFont systemFontOfSize:13];
        [backView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.right.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(13);
        }];
        self.desLabel = desLabel;
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [RSColor colorWithHexString:@"#cccccc"];
        [backView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.right.equalTo(titleLabel);
            make.top.equalTo(desLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(0.5);
        }];
        
        CGFloat imgViewH = 200;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.layer.cornerRadius = imgViewH / 2;
        imgView.layer.masksToBounds = YES;
        imgView.image = [UIImage imageNamed:@"WechatIMG886"];
        [backView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleLabel);
            make.top.equalTo(lineLabel.mas_bottom).offset(40);
            make.width.mas_equalTo(imgViewH);
            make.height.equalTo(imgView.mas_width);
        }];
        self.imgView = imgView;
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateSelected];
        [backView addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgView);
            make.centerY.equalTo(imgView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        self.playButton = playButton;
    }
    
    return self;
}

- (void)setMusicModel:(MusicModel *)musicModel
{
    _musicModel = musicModel;
    
    self.titleLabel.text = _musicModel.title;
    
    self.desLabel.text = _musicModel.des;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_musicModel.imgUrl] placeholderImage:nil];
    
    if (_musicModel.isPlay) {
        self.playButton.selected = YES;
        CAAnimation *animation = [self.imgView.layer animationForKey:@"rotationAnimation"];
        if (!animation) {
            [HXAnimation rotateView:self.imgView];
        }
        [HXAnimation resumeAnimation:self.imgView];//恢复动画
    } else {
        self.playButton.selected = NO;
        [HXAnimation pauseAnimation:self.imgView];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

- (void)playButtonClick
{
    self.playButton.selected = !self.playButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(playButtonClick:isPlay:)]) {
        [self.delegate playButtonClick:self.indexPath isPlay:self.playButton.selected];
    }
}

- (void)play
{
    self.playButton.selected = YES;
    CAAnimation *animation = [self.imgView.layer animationForKey:@"rotationAnimation"];
    if (!animation) {
        [HXAnimation rotateView:self.imgView];
    }
    [HXAnimation resumeAnimation:self.imgView];//恢复动画
}

- (void)pause
{
    self.playButton.selected = NO;
    [HXAnimation pauseAnimation:self.imgView];
}

@end
