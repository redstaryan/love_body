//
//  HomeHeaderView.m
//  YSLife
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HomeHeaderView.h"
#import "GlobalDefines.h"

@implementation HomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *vLabel = [[UILabel alloc] init];
        vLabel.frame = CGRectMake(0, 0, self.frame.size.width, 10);
        vLabel.backgroundColor = [RSColor colorWithHexString:@"#f8f8f8"];
        [self addSubview:vLabel];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.frame = CGRectMake(15, 34,  4, 14);
        leftLabel.backgroundColor = [RSColor colorWithHexString:@"#42b72a"];
        [self addSubview:leftLabel];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _titleLabel.frame = CGRectMake(27,self.frame.size.height - 16, self.frame.size.width,16);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
