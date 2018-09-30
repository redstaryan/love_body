//
//  MusicModel.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/27.
//  Copyright © 2016年 yoke121. All rights reserved.
// 音乐模型

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property(nonatomic,copy) NSString *musicId;//歌曲编号
@property(nonatomic,copy) NSString *title;//标题
@property(nonatomic,copy) NSString *des;//简介
@property(nonatomic,copy) NSString *imgUrl;//封面地址
@property(nonatomic,copy)NSString *fileUrl;
@property(nonatomic,assign) BOOL isPlay;//是否正在播放
@end
