//
//  NewsDetailModel.h
//  YSLife
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsDetailModel : NSObject

/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻配图(希望这个数组中以后放HMNewsDetailImg模型) */
@property (nonatomic, strong) NSArray *imgArray;
/** 模块名*/
@property(nonatomic,copy)NSString *replyBoard;
/** 回复数*/
@property(nonatomic,assign)NSInteger replyCount;

+ (instancetype)detailWithDict:(NSDictionary *)dict;

/**
 *  将拼接html的操作在业务逻辑层做
 *
 *  @return 将拼好后的html字符串返回
 */
- (NSString *)getHtmlString:(NewsDetailModel *)detailModel;

@end
