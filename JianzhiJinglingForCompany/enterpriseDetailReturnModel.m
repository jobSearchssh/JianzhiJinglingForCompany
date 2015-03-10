//
//  enterpriseDetailModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "enterpriseDetailReturnModel.h"

@implementation enterpriseDetailReturnModel
-(enterpriseDetailReturnModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
        NSError *error;
        NSData* aData = [receiveStr dataUsingEncoding: NSASCIIStringEncoding];
        NSDictionary *a = Nil;
        BOOL flag = TRUE;
        @try {
            a = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
        }
        @catch (NSException *exception) {
            a = Nil;
            flag = false;
        }
        if (flag) {
            @try {
                status = [a objectForKey:@"status"];
                info = [a objectForKey:@"info"];
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (flag) {
            @try {
                NSDictionary *dic = [a objectForKey:@"datas"];
                detail = [[enterpriseDetailModel alloc]initWithDictionary:dic];
            }
            @catch (NSException *exception) {
                NSLog(@"enterpriseDetailModel error");
                flag = false;
            }
        }
        if (!flag) {
            status = [NSNumber numberWithInt:BASE_FAILED];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}
-(enterpriseDetailReturnModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}
-(enterpriseDetailModel *)getenterpriseDetailModel{
    return detail;
}
@end
