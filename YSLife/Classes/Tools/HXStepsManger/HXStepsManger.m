//
//  HXStepsManger.m
//  YSLife
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "HXStepsManger.h"

@interface HXStepsManger()
@property (nonatomic, strong) CMPedometer *pedometer;
@end

static HXStepsManger * _instance = nil;

@implementation HXStepsManger

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype) sharedStepsManger {
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if(self){
        //初始化
        self.pedometer = [[CMPedometer alloc]init];
        
        //判断记步功能
        if ([CMPedometer isStepCountingAvailable]) {
            //当你的步数有更新的时候，会触发这个方法，返回从某一时刻开始到现在所有的信息统计CMPedometerData。
            //其中CMPedometerData包含步数等信息，在下面使用的时候介绍。
            //值得一提的是这个方法不会实时返回结果，每次刷新数据大概一分钟左右。
            [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                NSLog(@"我已经走了%@步",pedometerData.numberOfSteps);
                NSLog(@"距离%@米",pedometerData.distance);
            }];
        }else{
            NSLog(@"记步功能不可用");
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)queryPedometerSteps:(ResultData)resultData
{
    //我查询从今天0点到现在我走了多少步
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    [self.pedometer queryPedometerDataFromDate:startOfToday toDate:[NSDate dateWithTimeIntervalSinceNow:0] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
    }];
}

@end
