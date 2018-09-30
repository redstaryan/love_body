//
//  NewsDetailModel.m
//  YSLife
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "NewsDetailModel.h"
#import "NewsDetailImgModel.h"

@implementation NewsDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {//一定要调回父类的方法
        self.title = dict[@"title"];
        self.ptime = dict[@"ptime"];
        self.body = dict[@"body"];
        self.replyBoard = dict[@"replyBoard"];
        self.replyCount = [dict[@"replyCount"] integerValue];
        
        NSArray *imgArray = dict[@"img"];
        NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:imgArray.count];
        for (NSDictionary *dict in imgArray) {
            NewsDetailImgModel *imgModel = [NewsDetailImgModel detailImgWithDict:dict];
            [temArray addObject:imgModel];
        }
        self.imgArray = temArray;
    }
    return self;
}

+ (instancetype)detailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

#pragma mark - **************** 业务逻辑
- (NSString *)getHtmlString:(NewsDetailModel *)detailModel
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"NewsDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString:detailModel]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    return html;
}

- (NSString *)getBodyString:(NewsDetailModel *)detailModel
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",detailModel.ptime];
    if (detailModel.body != nil) {
        [body appendString:detailModel.body];
    }
    for (NewsDetailImgModel *detailImgModel in detailModel.imgArray) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

@end
