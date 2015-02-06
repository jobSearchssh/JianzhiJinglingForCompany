//
//  baseModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_QUERY_ERROR @"查询失败"
#define BASE_OK @"查询成功"
#define BASE_CREATE_ERROR @"创建失败"
#define BASE_INVALID_INPUT @"输入错误"
#define BASE_INVALID_USER @"用户信息错误，无该用户"

#define BASE_SUCCESS 0
#define BASE_FAILED 1
#define BASE_SPAN 10

@interface baseModel : NSObject{
    NSNumber *status;
    NSString *info;
    NSNumber *count;
}

-(NSNumber *)getStatus;
-(NSNumber *)getCount;
-(NSString *)getInfo;

@end
