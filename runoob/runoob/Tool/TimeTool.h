//
//  TimeTool.h
//  runoob
//
//  Created by zhoubaitong on 2017/8/18.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject

/** 获取当前的时间 */
+ (NSString*)getCurrentTimes;

/** 计算两个日期之间的天数 */
+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

@end
