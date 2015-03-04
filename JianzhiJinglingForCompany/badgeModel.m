//
//  badgeModel.m
//  jobSearch
//
//  Created by RAY on 15/2/20.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "badgeModel.h"

@implementation badgeModel

-(badgeModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",receiveStr);
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
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = @"解析错误,请重新尝试";
        }
        
        if (flag && status.intValue == STATIS_OK) {
            do{
                NSDictionary *dictionary = nil;
                @try {
                    dictionary = [a objectForKey:@"count"];
                }
                @catch (NSException *exception) {
                    NSLog(@"datas 解析不成功");
                    dictionary = Nil;
                    flag = false;
                }
                if (dictionary == Nil) {
                    NSLog(@"datas 为空");
                    flag = false;
                    break;
                }
                
                @try {
                    inviteNotRead = [dictionary objectForKey:@"inviteNotRead"];
                    applyNotRead = [dictionary objectForKey:@"applyNotRead"];
                }
                @catch (NSException *exception) {
                    NSLog(@"datas 解析错误");
                    flag = false;
                    break;
                }
            }while (FALSE);
        }else{
            NSLog(@"status 不成功");
            return self;
        }
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}

-(badgeModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}

-(NSString *)getinviteNotRead{
    return inviteNotRead;
}
-(NSString *)getapplyNotRead{
    return applyNotRead;
}


@end
