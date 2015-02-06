//
//  loginModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#define STATIS_OK 0
#define STATIS_NO 1

@interface loginModel : NSObject{
    NSNumber *status;
    NSString *info;
    NSString *usrID;
}

-(loginModel *)initWithData:(NSData *)mainData;
-(loginModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error usrID:(NSString *)defaultID;
-(NSNumber *)getStatus;
-(NSString *)getInfo;
-(NSString *)getUsrID;
@end
