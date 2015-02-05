//
//  User.m
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "User.h"

@implementation User
static User* user=nil;

+ (User *)getCurrentUser{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    ;

    if ([mySettingData objectForKey:@"currentUserObjectId"] !=nil) {
        @synchronized(self)
        {
            if (!user){
                user = [[User alloc] init];
            }
            user.userObjectId=[mySettingData objectForKey:@"currentUserObjectId"];
            user.userName=[mySettingData objectForKey:@"userName"];
            
            return user;
        }
    }else
        
        return nil;
}

+ (void)clearCurrentUser{
    
    user.userObjectId=nil;
    user.userName=nil;
    user.userPhone=nil;
    user.userType=nil;
    user.userEmail=nil;
    
}

@end
