//
//  TodayTableViewCell.m
//  YSLife
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "TodayTableViewCell.h"
#import "GlobalDefines.h"
#import "PlaceholderTextView.h"

@interface TodayTableViewCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) PlaceholderTextView *textView;
@end

@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"早餐: ";
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(KLRMarginValue);
            make.right.equalTo(self.contentView).offset(-KLRMarginValue);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(15);
        }];
        self.titleLabel = titleLabel;
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(KLRMarginValue + 10);
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.mas_equalTo(1);
        }];
        
        UIView *itemView = [[UIView alloc] init];
        itemView.layer.cornerRadius = 5;
        itemView.layer.borderColor = [UIColor blackColor].CGColor;
        itemView.layer.borderWidth = 1;
        [self.contentView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineLabel).offset(KLRMarginValue);
            make.right.equalTo(self.contentView).offset(-KLRMarginValue);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-30);
        }];
        
        //详细内容
        PlaceholderTextView *textView = [[PlaceholderTextView alloc]init];
        textView.placeholderLabel.font = [UIFont systemFontOfSize:13];
        textView.backgroundColor = [RSColor colorWithHexString:@"#f7f7f7"];
        textView.placeholder = @"早餐自己做的？？？";
        textView.font = [UIFont systemFontOfSize:15];
        textView.maxLength = 30;
        textView.layer.cornerRadius = 2.f;
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = [UIColor blackColor].CGColor;
        [itemView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(10);
            make.right.equalTo(itemView).offset(-10);
            make.top.equalTo(itemView).offset(10);
            make.height.mas_equalTo(60);
        }];
        self.textView = textView;
        
        CGFloat cameraButtonW = 60;
        for(int i=0 ; i< 3; i++) {
            CGFloat cameraButtonX = KLRMarginValue * (i+1) + cameraButtonW*i;
            UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cameraButton.layer.borderWidth = 1;
            cameraButton.tag = 100 + i;
            cameraButton.layer.borderColor = [UIColor blackColor].CGColor;
            [cameraButton setImage:[UIImage imageNamed:@"it_icon_camera"] forState:UIControlStateNormal];
            [cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:cameraButton];
            [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(itemView).offset(cameraButtonX);
                make.top.equalTo(textView.mas_bottom).offset(KLRMarginValue);
                make.width.mas_equalTo(cameraButtonW);
                make.height.mas_equalTo(cameraButtonW);
            }];
            if (i!=0) {
                cameraButton.hidden = YES;
            }
        }
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.layer.borderWidth = 1;
        sendButton.layer.borderColor = [UIColor blackColor].CGColor;
        [sendButton setTitle:@"开动" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemView addSubview:sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(itemView).offset(-KLRMarginValue);
            make.bottom.equalTo(itemView).offset(-KLRMarginValue);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
        }];
        
    }
    return self;
}

- (void)setTodayModel:(TodayModel *)todayModel
{
    _todayModel = todayModel;
    
    NSString *title= todayModel.title;
    NSMutableAttributedString *attriStr=[[NSMutableAttributedString alloc]initWithString:title];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:[RSColor colorWithHexString:@"#cccccc"]} range:NSMakeRange(3, _todayModel.title.length-3)];
    self.titleLabel.attributedText = attriStr;
    
    self.textView.placeholder = _todayModel.content;
    
    if (_todayModel.lastSelectPhotos.count >=3) {
        for (int i=0; i<3; i++) {
            UIButton *cameraButton = [self.contentView viewWithTag:100+i];
            cameraButton.hidden = NO;
            [cameraButton setImage:_todayModel.lastSelectPhotos[i] forState:UIControlStateNormal];
        }
    } else {
        for (int i=0; i<3; i++) {
            UIButton *cameraButton = [self.contentView viewWithTag:100+i];
            cameraButton.hidden = NO;
            [cameraButton setImage:_todayModel.lastSelectPhotos[i] forState:UIControlStateNormal];
        }
    }
}

- (void)cameraButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickCameraButton:)]) {
        [self.delegate didClickCameraButton:self.indexPath];
    }
}

- (void)sendButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickSendButton:)]) {
        [self.delegate didClickSendButton:self.indexPath];
    }
}

@end
