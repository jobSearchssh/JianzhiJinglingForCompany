//
//  iniviteModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/3/3.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jobModel.h"
#import "userModel.h"


#define invite_inviteStatus @"inviteStatus"
#define invite_invite_id @"invite_id"
#define invite_enterpriseInviteIsRead @"enterpriseInviteIsRead"

@interface iniviteModel : NSObject{
    NSNumber *inviteStatus;
    NSString *invite_id;
    NSString *enterpriseInviteIsRead;
    jobModel *jobmodel;
    userModel *usermodel;
}
-(iniviteModel *)initWithDictionary:(NSDictionary *)initDictionary;
-(NSNumber *)getinviteStatus;
-(NSString *)getinvite_id;
-(NSString *)getenterpriseInviteIsRead;
-(jobModel *)getjobModel;
-(userModel *)getuserModel;

@end
