//
//  DateUtil.m
//  myPassWordWallet
//
//  Created by 田原 on 14-2-23.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "DateUtil.h"
static long long daySeconds = 60*60*24;
@implementation DateUtil

+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+(NSString *)birthdayStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+(NSString *)startTimeStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+(NSString *)msgTimetoCurrent:(NSDate *)date{
    NSString *returnString;
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:[NSDate date]];
        NSString *msgday = [dateFormatter stringFromDate:date];
        NSTimeInterval secondsBetweenDates= [[NSDate date] timeIntervalSinceDate:date];
        if ([today isEqualToString:msgday]) {
            [dateFormatter setDateFormat:@"hh:mm"];
            returnString = [dateFormatter stringFromDate:date];
        }else{
            if (secondsBetweenDates < daySeconds) {
                returnString = [[NSString alloc]initWithFormat:@"一天前"];
            }else if (secondsBetweenDates > daySeconds && secondsBetweenDates < daySeconds*2) {
                returnString = [[NSString alloc]initWithFormat:@"两天前"];
            }else{
                returnString = msgday;
            }
        }
    }
    @catch (NSException *exception) {
        returnString = Nil;
    }
    return returnString;
}
@end
