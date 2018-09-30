//
//  HXDateTool.h
//  YSLife
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDateTool : NSObject

/** 获取当前时间的时间戳（NSTimeInterval）*/
+ (NSTimeInterval)currentTimeStamp;

/** 获取当前时间的时间戳（NSString）*/
+ (NSString *)currentTimeStampStr;

/** 获取当前时间 (YYYY/MM/dd hh:mm:ss SS) */
+ (NSString *)currentDateStr;

/** 时间戳(NSString)转指定格式时间(yyyy-MM-dd hh:mm) */
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;

/** 字符串(YYYY/MM/dd hh:mm:ss SS)转时间戳(NSString) */
+ (NSString *)getTimeStrWithString:(NSString *)str;

/** 将时间戳转换为格式化后的字符串 (刚刚 几分钟前 几小时前 几天以前...) */
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;

/** 计算从 startTingDate 到 resultDate 相差的时间 */
+ (NSDateComponents *)dateDiffFromDate:(NSDate *)startTingDate toDate:(NSDate *)resultDate;

/** 判断某一日期(date)是否为今天 */
+ (BOOL)isToday:(NSDate *)date;

/** 判断某一日期(date)是否为昨天 */
+ (BOOL)isYesterday:(NSDate *)date;

/** 判断某一日期(date)是否为明天 */
+ (BOOL)isTomorrow:(NSDate *)date;

/** 判断某一日期(date)是否为今年 */
+ (BOOL)isThisYear:(NSDate *)date;

/** 获取某一日期(date)的星期 */
+ (NSString *)weekdayStringFromDate:(NSDate *)date;

@end
