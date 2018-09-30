//
//  UILabel+extension.h
//  YSLife
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  获取富文本的高度
 */
+ (CGFloat)getHeightForLabel:(UILabel *)label withWidth:(CGFloat)width;

@end
