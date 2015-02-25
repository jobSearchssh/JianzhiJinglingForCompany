//
//  userListModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "userListModel.h"

@implementation userListModel

-(userListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}
//json 解析
-(userListModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        BOOL flag = TRUE;
        do{
            NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
            NSError *error;
            NSData* aData = [receiveStr dataUsingEncoding: NSASCIIStringEncoding];
            NSDictionary *a = Nil;
            @try {
                a = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
            }
            @catch (NSException *exception) {
                a = Nil;
                flag = false;
                break;
            }
            
            //super
            if (flag) {
                @try {
                    status = [a objectForKey:@"status"];
                    info = [a objectForKey:@"info"];
                    count = [a objectForKey:@"count"];
                }
                @catch (NSException *exception) {
                    NSLog(@"status解析错误");
                    flag = false;
                    break;
                }
            }
            
            if (flag) {
                if (status.intValue == BASE_FAILED) {
                    break;
                }
                userList = [[NSMutableArray alloc]init];
                NSArray *jobsJSON = Nil;
                @try {
                    jobsJSON = [a objectForKey:@"datas"];
                }
                @catch (NSException *exception) {
                    NSLog(@"datas解析错误");
                    flag = false;
                    break;
                }
                if (jobsJSON != Nil) {
                    @try {
                        for (NSDictionary *dictionary in jobsJSON) {
                            @try {
                                userModel *user = [[userModel alloc]initWithDictionary:dictionary];
                                if (user != Nil) {
                                    [userList addObject:user];
                                }
                            }
                            @catch (NSException *exception) {
                                NSLog(@"jobModel-error");
                                continue;
                            }
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"jobsJSON解析错误");
                        flag = false;
                        break;
                    }
                }
            }
        }while (FALSE);
        
        if (!flag) {
            status = [NSNumber numberWithInt:BASE_FAILED];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}

-(NSMutableArray *)getuserArray{
    return userList;
}
@end
