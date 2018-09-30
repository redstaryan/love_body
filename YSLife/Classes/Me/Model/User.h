//
//  User.h
//  YSLife
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 redstar. All rights reserved.
//

typedef enum {
    LoginStateSuccess,
    LoginStateOut
} LoginState;

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *telPhone;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign) LoginState loginState;

@end
