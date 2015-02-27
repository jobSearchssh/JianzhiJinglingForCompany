//
//  MLLoginBusiness.m
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLoginBusiness.h"
#import <BmobSDK/Bmob.h>
#import "MLLoginBusiness.h"
#import "netAPI.h"
#import "User.h"

@implementation MLLoginBusiness

- (void)registerInBackground:(NSString*)username Password:(NSString*)pwd{
    
      MLLoginBusiness *__weak weakself=self;
    [netAPI enterpriseRegister:username usrPassword:pwd withBlock:^(registerModel *registerModel) {
        if(registerModel!=nil)
        {
            if ([[registerModel getStatus]intValue]==STATIS_NO) {
                [weakself registerIsSucceed:NO feedback:[registerModel getInfo]];
                
            }else if([[registerModel getStatus]intValue]==STATIS_OK)
            {
              //user本地化
                [weakself saveUserInfoLocally:username usrID:[registerModel getUsrID]];
                [weakself registerIsSucceed:YES feedback:@"注册成功"];
                
            }
        }
    }];
    
//    BmobQuery *query=[BmobQuery queryWithClassName:@"JobUser"];
//    [query whereKey:@"userName" equalTo:username];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (!error) {
//            if ([array count]==0) {
//                BmobObject *jobUser=[BmobObject objectWithClassName:@"JobUser"];
//                [jobUser setObject:username forKey:@"userName"];
//                [jobUser setObject:pwd forKey:@"userPassword"];
//                [jobUser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                    if (isSuccessful) {
//                        [self saveUserInfoLocally:jobUser];
//                        [self registerIsSucceed:YES feedback:@"注册成功"];
//                    }else{
//                        [self registerIsSucceed:NO feedback:@"网络请求错误，注册失败"];
//                    }
//                }];
//            }else{
//                [self registerIsSucceed:NO feedback:@"该用户名已被注册"];
//            }
//        }else{
//            [self registerIsSucceed:NO feedback:@"网络请求错误，注册失败"];
//        }
//    }];
    
    
}

-(void)registerIsSucceed:(BOOL)result feedback:(NSString*)feedback{
    NSLog(@"%@",feedback);
    [self.registerResultDelegate registerResult:result Feedback:feedback];
}

-(void) loginInBackground:(NSString*) username Password:(NSString*)pwd{
    
    MLLoginBusiness *__weak weakself=self;
    [netAPI enterpriseLogin:username usrPassword:pwd withBlock:^(loginModel *loginModel) {
        if(loginModel!=nil)
        {
            if ([[loginModel getStatus]intValue]==STATIS_NO) {
                [weakself registerIsSucceed:NO feedback:[loginModel getInfo]];
                
            }else if([[loginModel getStatus]intValue]==STATIS_OK)
            {
                //user本地化
                [weakself saveUserInfoLocally:username usrID:[loginModel getUsrID]];
                [weakself loginIsSucceed:YES feedback:@"注册成功"];
            }
        }

    }];
}

-(void)loginIsSucceed:(BOOL)result feedback:(NSString*)feedback
{
    NSLog(@"%@",feedback);

    [self.loginResultDelegate loginResult:result Feedback:feedback];

}


- (void)saveUserInfoLocally:(NSString*)usrname usrID:(NSString*)objectId{
    
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:usrname forKey:CURRENTUSERNAME];
        [mySettingData setObject:objectId forKey:CURRENTUSERID];
        [mySettingData synchronize];
    
    
    NSLog(@"登录成功:%@",[mySettingData objectForKey:CURRENTUSERNAME]);

}




+ (void)logout{
    //登出操作
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:CURRENTUSERID]) {
        [mySettingData setObject:nil forKey:CURRENTUSERNAME];
        [mySettingData setObject:nil forKey:CURRENTUSERID];
        [mySettingData synchronize];
    }
}

@end
