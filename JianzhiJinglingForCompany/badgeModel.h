//
//  badgeModel.h
//  jobSearch
//
//  Created by RAY on 15/2/20.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"

#define STATIS_OK 0
#define STATIS_NO 1

@interface badgeModel : baseModel
{
    NSString *inviteNotRead;
    NSString *applyNotRead;
}

-(badgeModel *)initWithData:(NSData *)mainData;
-(badgeModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSString *)getinviteNotRead;
-(NSString *)getapplyNotRead;

@end
