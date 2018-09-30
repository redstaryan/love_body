//
//  NewsDetailImgModel.h
//  YSLife
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailImgModel : NSObject

@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

+ (instancetype)detailImgWithDict:(NSDictionary *)dict;

@end
