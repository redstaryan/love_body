//
//  NewsModel.h
//  YSLife
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsModel : NSObject
@property (nonatomic, copy) NSString *newsId;//新闻ID
@property (nonatomic, copy) NSString *pTime;//发布时间
@property (nonatomic, copy) NSString *source;//新闻来源
@property (nonatomic, copy) NSString *title;//新闻标题
@property (nonatomic, copy) NSString *body;//新闻内容
@property (nonatomic, copy) NSString *shareLink;//分享链接
@property (nonatomic, copy) NSString *brief;//简介
@property (nonatomic, copy) NSString *briefImage;//简介图片

/** 新闻配图(数组中放NewsImgModel模型) */
@property (nonatomic, strong) NSArray *newsImages;

/**
 *  将拼接html的操作在业务逻辑层做
 *
 *  @return 将拼好后的html字符串返回
 */
- (NSString *)getHtmlString:(NewsModel *)newsModel;

@end
