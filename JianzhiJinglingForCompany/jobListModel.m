//
//  jobsModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobListModel.h"

@implementation jobListModel

-(jobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}

-(jobListModel *)initWithData:(NSData *)mainData{
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
                savejobsArray = [[NSMutableArray alloc]init];
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
                                jobModel *job = [[jobModel alloc]initWithDictionary:dictionary];
                                if (job != Nil) {
                                    [savejobsArray addObject:job];
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

-(NSMutableArray *)getJobArray{
    return savejobsArray;
}
@end
