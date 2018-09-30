//
//  RSColor.h
//  UWT
//
//  Created by redstar on 2018/1/26.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface RSColor : NSObject

+ (UIColor *)colorWithRed:(CGFloat)red withGreen:(CGFloat)green withBlue:(CGFloat)blue withAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)clearColor;

+ (UIColor *)whiteColor;

+ (UIColor *)blackColor;

@end
