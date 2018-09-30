//
//  AVVideoModel.h
//  YSLife
//
//  Created by admin on 2018/5/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVVideoModel : UIView
@property (nonatomic, copy) NSString *videoId;//视频的ID
@property (nonatomic, copy) NSString *videourl;//视频的地址
@property (nonatomic, copy) NSString *describe;//视频的描述
@property (nonatomic, copy) NSString *imageurl;//视频覆盖图片
@property (nonatomic, copy) NSString *category;//视频的类型
@property (nonatomic, copy) NSString *videotype;//视频的分类
@end
