//
//  GlobalDefines.h
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#ifndef GlobalDefines_h

#import "NetWorkManager.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#import "RSTextField.h"
#import "RSColor.h"
#import "ZLPhotoActionSheet.h"
#import "MJRefresh.h"
#import <AliyunPlayerSDK/AlivcMediaPlayer.h>
#import "PlaceholderTextView.h"
#import "BaseView.h"
#import "MJExtension.h"
#import "UILabel+extension.h"
#import "HXDateTool.h"
#import "HXShareTool.h"

#define KGreenColor @"#21C0AE"  //整体颜色风格

#define KLRMarginValue 15  //离屏幕左右边距

//阿里云地址
//#define KYSBaseURL @"http://106.15.205.92:8080/MavenTest/"

//本地mac地址
#define KYSBaseURL @"http://10.202.11.159:8087/MavenTest/"

//#define KYSBaseURL @"http://192.168.1.102:8020/MavenTest/"

// app尺寸
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width

//屏幕适配
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define KHeight_NavigationBar 44
#define KHeight_StatusBarMargin (kDevice_Is_iPhoneX ? 24.f:0.f)
#define KHeight_StatusBar 20
#define KHeight_TabBar (kDevice_Is_iPhoneX ? 34.f : 0.f)
#define KHeight_topNav (KHeight_NavigationBar + KHeight_StatusBar + KHeight_StatusBarMargin)

#define GlobalDefines_h
#endif /* GlobalDefines_h */
