//
//  NewsModel.m
//  YSLife
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "NewsModel.h"
#import "NewsImgModel.h"
#import "GlobalDefines.h"

@implementation NewsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"newsImages" : @"NewsImgModel"};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"newsId":@"newsId",
             @"pTime":@"pTime",
             @"source":@"source",
             @"title":@"title",
             @"body":@"body",
             @"shareLink":@"shareLink",
             @"brief":@"brief",
             @"briefImage":@"briefImage",
             @"newsImages":@"newsImages"};
}

#pragma mark - **************** 业务逻辑
- (NSString *)getHtmlString:(NewsModel *)newsModel
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"NewsDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString:newsModel]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    return html;
}

- (NSString *)getBodyString:(NewsModel *)newsModel
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",newsModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",[HXDateTool getDateStringWithTimeStr:newsModel.pTime]];
    if (newsModel.body != nil) {
        [body appendString:newsModel.body];
    }
    for (NewsImgModel *newsImgModel in newsModel.newsImages) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [newsImgModel.pixel componentsSeparatedByString:@"*"];
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
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,newsImgModel.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:newsImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

@end
