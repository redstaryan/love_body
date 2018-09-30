//
//  NewsImgModel.h
//  YSLife
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsImgModel : NSObject

@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

@end
