//
//  HXStepsManger.h
//  YSLife
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

/**定义请求成功的block*/
typedef void(^ResultData)(CMPedometerData * _Nullable pedometerData);

@interface HXStepsManger : NSObject

+ (instancetype) sharedStepsManger;

- (void)queryPedometerSteps:(ResultData)resultData;

@end
