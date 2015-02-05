//
//  MLLoginBusiness.m
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLoginBusiness.h"
#import <BmobSDK/Bmob.h>

@implementation MLLoginBusiness

- (void)registerInBackground:(NSString*)username Password:(NSString*)pwd{
    
    BmobQuery *query=[BmobQuery queryWithClassName:@"JobUser"];
    [query whereKey:@"userName" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            if ([array count]==0) {
                BmobObject *jobUser=[BmobObject objectWithClassName:@"JobUser"];
                [jobUser setObject:username forKey:@"userName"];
                [jobUser setObject:pwd forKey:@"userPassword"];
                [jobUser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self saveUserInfoLocally:jobUser];
                        [self registerIsSucceed:YES feedback:@"注册成功"];
                    }else{
                        [self registerIsSucceed:NO feedback:@"网络请求错误，注册失败"];
                    }
                }];
            }else{
                [self registerIsSucceed:NO feedback:@"该用户名已被注册"];
            }
        }else{
            [self registerIsSucceed:NO feedback:@"网络请求错误，注册失败"];
        }
    }];
}

-(void)registerIsSucceed:(BOOL)result feedback:(NSString*)feedback{
    NSLog(@"%@",feedback);
    [self.registerResultDelegate registerResult:result Feedback:feedback];
}

-(void) loginInBackground:(NSString*) username Password:(NSString*)pwd{
    BmobQuery *query=[BmobQuery queryWithClassName:@"JobUser"];
    [query whereKey:@"userName" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            if ([array count]>0) {
                BmobObject *object=[array firstObject];
                NSLog(@"%@",[object objectForKey:@"userPassword"]);
                if ([pwd isEqualToString:[object objectForKey:@"userPassword"]]) {
                    [self saveUserInfoLocally:object];
                    [self loginIsSucceed:YES feedback:@"登录成功"];
                }else{
                    [self loginIsSucceed:NO feedback:@"密码错误"];
                }
            }else{
                [self loginIsSucceed:NO feedback:@"该用户不存在"];
            }
        }else{
            [self loginIsSucceed:NO feedback:@"请求错误"];
        }
    }];
}

-(void)loginIsSucceed:(BOOL)result feedback:(NSString*)feedback
{
    NSLog(@"%@",feedback);

    [self.loginResultDelegate loginResult:result Feedback:feedback];

}

- (void)saveUserInfoLocally:(BmobObject *)jobUser{
    if (jobUser) {
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:[jobUser objectForKey:@"userName"] forKey:@"currentUserName"];
        [mySettingData setObject:jobUser.objectId forKey:@"currentUserObjectId"];
        [mySettingData synchronize];
    }
}

+ (void)logout{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"currentUserObjectId"]) {
        [mySettingData setObject:nil forKey:@"currentUserName"];
        [mySettingData setObject:nil forKey:@"currentUserObjectId"];
        [mySettingData synchronize];
    }
}

@end
