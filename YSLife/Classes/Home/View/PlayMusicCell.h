//
//  PlayMusicCell.h
//  YSLife
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDefines.h"
#import "MusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlayMusicCellDelegate <NSObject>
@optional
- (void)playButtonClick:(NSIndexPath *)indexPath isPlay:(BOOL)isPlay;
@end

@interface PlayMusicCell : UITableViewCell

@property (nonatomic, strong) MusicModel *musicModel;

@property (nonatomic, weak) id<PlayMusicCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
 
- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
