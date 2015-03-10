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
#import "enterpriseDetailModel.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
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
                [weakself registerIsSucceed:YES feedback:Text_RegistSuccess];
                
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
                [weakself loginIsSucceed:NO feedback:[loginModel getInfo]];
                
                
                
            }else if([[loginModel getStatus]intValue]==STATIS_OK)
            {
                //user本地化
                [weakself saveUserInfoLocally:username usrID:[loginModel getUsrID]];
                [weakself loginIsSucceed:YES feedback:Text_RegistSuccess];
                
            }
        }

    }];
}


-(void)loginComProfile
{
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    if ([mysettings objectForKey:COMPROFILEFlag]) {
        return;
    }
    NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
    [netAPI getEnterpriseDetail:com_id withBlock:^(enterpriseDetailReturnModel *detailModel) {
        if ([[detailModel getStatus]intValue]==BASE_SUCCESS) {
            enterpriseDetailModel *thisCompany=[detailModel getenterpriseDetailModel];
            //修改NSUserDefaults
            if (thisCompany!=nil)
            {
                NSString *comLogoURL=[NSString stringWithFormat:@"%@",[thisCompany getenterpriseLogoURL]];
                NSString *comIntro=[NSString stringWithFormat:@"%@",[thisCompany getenterpriseIntroduction]];
                NSString *comName=[NSString stringWithFormat:@"%@",[thisCompany getenterpriseName]];
                NSString *comIndusrty=[[[NSNumberFormatter alloc] init]stringFromNumber:[thisCompany getenterpriseIndustry]];
                NSString *comAddress=[NSString stringWithFormat:@"%@",[thisCompany getenterpriseAddressDetail]];
                
                [mysettings setObject:comLogoURL forKey:CURRENTLOGOURL];
                [mysettings setObject:comName forKey:CURRENTUSERREALNAME];
                [mysettings setObject:comIndusrty forKey:CURRENTUSERINDUSTRY];
                [mysettings setObject:comIntro forKey:CURRENTINTRODUCTION];
                [mysettings setObject:comAddress forKey:CURRENTUSERADDRESS];
                [mysettings setBool:YES forKey:COMPROFILEFlag];
                [mysettings synchronize];
            }
        }else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[detailModel getInfo]];
            [MBProgressHUD showError:error toView:nil];
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
        [self loginComProfile];
    
    NSLog(@"登录成功:%@",[mySettingData objectForKey:CURRENTUSERNAME]);

}

#pragma --mark 找回密码
- (void)resetPasswordInBackground:(NSString*)username Password:(NSString*)pwd{
    
    [netAPI usrResetPassword:username usrPassword:pwd withBlock:^(oprationResultModel *oprationResultModel) {
        if ([oprationResultModel.getStatus intValue]==0) {
            [self.resetResultDelegate resetPassword:YES Feedback:Text_PWDResetSuccess];
        }else{
            [self.resetResultDelegate resetPassword:NO Feedback:oprationResultModel.getInfo];
        }
    }];
}


+ (void)logout{
    //登出操作
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:CURRENTUSERID]) {
        [mySettingData setObject:nil forKey:CURRENTUSERNAME];
        [mySettingData setObject:nil forKey:CURRENTUSERID];
        [mySettingData setObject:nil forKey:CURRENTINTRODUCTION];
        [mySettingData setObject:nil  forKey:CURRENTLOGOURL];
        [mySettingData setObject:nil  forKey:CURRENTUSERADDRESS];
        
        [mySettingData setObject:nil forKey:CURRENTLOGOURL];
        [mySettingData setObject:nil forKey:CURRENTUSERREALNAME];
        [mySettingData setObject:nil forKey:CURRENTUSERINDUSTRY];
        [mySettingData setObject:nil forKey:CURRENTINTRODUCTION];
        [mySettingData setObject:nil forKey:CURRENTUSERADDRESS];
        [mySettingData setBool:NO forKey:COMPROFILEFlag];
        [mySettingData synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil];
    }
}

@end
