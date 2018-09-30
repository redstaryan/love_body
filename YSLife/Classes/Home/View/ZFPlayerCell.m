//
//  ZFPlayerCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import <Masonry/Masonry.h>
#import "GlobalDefines.h"

@interface ZFPlayerCell ()

@end

@implementation ZFPlayerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        // 设置imageView的tag，在PlayerView中取（建议设置100以上）
        self.picView.tag = 101;
        
        self.picView = [[UIImageView alloc] init];
        //self.picView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.picView.layer.masksToBounds = YES;
        self.picView.clipsToBounds = YES;
        self.picView.backgroundColor = [UIColor redColor];
        self.picView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.picView];
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(KScreenWidth);
            make.height.mas_equalTo(KScreenHeight);
        }];
        
        
        // 代码添加playerBtn到imageView上
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(100);
        }];
        
    }
    return self;
}

- (void)setModel:(ZFVideoModel *)model {
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = model.title;
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        CGFloat imgH = 0;
        CGSize imageSize = image.size;
        if (imageSize.height > 0) {
            //这里就把图片根据 固定的需求宽度  计算 出图片的自适应高度
            imgH = imageSize.height * KScreenWidth / imageSize.width;
        }
        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KScreenWidth);
            make.height.mas_equalTo(imgH);
        }];
    }];
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}


@end
