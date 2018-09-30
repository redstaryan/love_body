//
//  NewsTableViewCell.m
//  YSLife
//
//  Created by admin on 2018/5/27.
//  Copyright © 2018年 redstar. All rights reserved.
//

#define LRValue 15
#define TBValue 15

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()
@property (nonatomic, weak) UIImageView *imgView;//右边图片
@property (nonatomic, weak) UILabel *titleLabel;//新闻标题
@property (nonatomic, weak) UILabel *desLabel;//新闻描述（1.来源 2.浏览人数）
@end

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGFloat imgViewW = 100;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(TBValue);
            make.right.equalTo(self.contentView).offset(-LRValue);
            make.bottom.equalTo(self.contentView).offset(-TBValue);
            make.width.mas_equalTo(imgViewW);
        }];
        self.imgView = imgView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(LRValue,TBValue,KScreenWidth - 3 *  LRValue -imgViewW ,100);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.textColor = [RSColor colorWithHexString:@"#999999"];
        desLabel.font = [UIFont systemFontOfSize:14];
        desLabel.text = @"养生日报   1000人阅读";
        [self.contentView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(LRValue);
            make.bottom.equalTo(self.contentView).offset(-TBValue);
            make.right.equalTo(imgView.mas_left).offset(-LRValue);
            make.height.mas_equalTo(14);
        }];
        self.desLabel = desLabel;
    }
    return self;
}

- (void)setNewsModel:(NewsModel *)newsModel
{
    _newsModel = newsModel;
    
    NSURL *imgUrl = [NSURL URLWithString:newsModel.briefImage];
    [self.imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    
    self.titleLabel.text = _newsModel.title;
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:5];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
