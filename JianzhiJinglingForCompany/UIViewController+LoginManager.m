//
//  UIViewController+LoginManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "UIViewController+LoginManager.h"
#import "MLLoginVC.h"
#import "CompanyResumeViewController.h"
#import "MLNaviViewController.h"
#import "MainTabBarViewController.h"
@implementation UIViewController (LoginManager)
+(BOOL)isLogin
{
    NSUserDefaults *mySetting=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySetting objectForKey:CURRENTUSERID];
    if (com_id!=nil) {
        return YES;
    }
    return NO;
}


+(BOOL)isUpLoadComProfile
{
    NSUserDefaults *mySetting=[NSUserDefaults standardUserDefaults];
    BOOL comProfileflag=[mySetting boolForKey:COMPROFILEFlag];
    if (comProfileflag) {
        return YES;
    }
    return NO;
}


-(void)notSettingprofile
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未填写企业信息，为了不影响您使用，请先去补充？" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"马上去", nil];
    alertView.tag=323435;
    [alertView show];
}


-(void)notLoginHandler
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"还未登录，请先登录" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"马上去", nil];
    alertView.tag=323432;
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (alertView.tag) {
        case 323432:
        {
            if (buttonIndex==1) {
                MLNaviViewController *navi=[[MLNaviViewController alloc]initWithRootViewController:[MLLoginVC sharedInstance]];
             [self presentViewController:navi animated:YES completion:^{
                 
             }];
            }
            break;
        }
        case 323435:
        {
            if (buttonIndex==1) {
                
            
//                CompanyResumeViewController *profile=[[CompanyResumeViewController alloc]init];
//                profile.enterprise=nil;
//                [self presentViewController:profile animated:YES completion:^{
//                    
//                }];
                [MainTabBarViewController shareInstance].selectedIndex=4;
            }
            break;
        }
        default:
            break;
    }


}


+(void)timeOut
{
    

}
@end
