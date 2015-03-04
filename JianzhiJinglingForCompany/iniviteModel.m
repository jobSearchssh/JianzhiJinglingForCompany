//
//  iniviteModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/3/3.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "iniviteModel.h"
#import <MAMapKit/MAMapKit.h>

@implementation iniviteModel
-(iniviteModel *)initWithDictionary:(NSDictionary *)initDictionary{
    self = [super init];
    if (self) {
        
        
        
        inviteStatus = [initDictionary objectForKey:invite_inviteStatus];
        invite_id = [initDictionary objectForKey:invite_invite_id];
        enterpriseInviteIsRead = [initDictionary objectForKey:invite_enterpriseInviteIsRead];
        
        jobmodel = [[jobModel alloc]initWithDictionary:initDictionary];
        usermodel = [[userModel alloc]initWithDictionary:initDictionary];
        
    }
    return self;
}
-(NSNumber *)getinviteStatus{
    return inviteStatus;
}
-(NSString *)getinvite_id{
    return invite_id;
}
-(NSString *)getenterpriseInviteIsRead{
    return enterpriseInviteIsRead;
}

-(jobModel *)getjobModel{
    return jobmodel;
}
-(userModel *)getuserModel{
    return usermodel;
}

@end
