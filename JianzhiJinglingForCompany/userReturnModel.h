//
//  userReturnModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/7.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#define STATIS_OK 0
#define STATIS_NO 1
@interface userReturnModel : baseModel{
    NSString *user_id;
}

-(userReturnModel *)initWithData:(NSData *)mainData;
-(userReturnModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error usrID:(NSString *)defaultID;
-(NSString *)getUserID;
@end
