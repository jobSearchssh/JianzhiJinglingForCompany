//
//  registerModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "registerModel.h"

@implementation registerModel
-(registerModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error usrID:(NSString *)defaultID{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
        usrID = defaultID;
    }
    return self;
}

-(registerModel *)initWithData:(NSData *)mainData{
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
                usrID = [a objectForKey:@"datas"];
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = @"解析错误,请重新尝试";
            usrID = @"-1";
        }
    }
    return self;
}
-(NSNumber *)getStatus{
    return status;
}
-(NSString *)getInfo{
    return info;
}
-(NSString *)getUsrID{
    return usrID;
}
@end
