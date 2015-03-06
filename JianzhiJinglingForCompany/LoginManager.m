//
//  LoginManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#define loginAlertTag 323432
#define settingsAlertTag 323435
#define selectOK 1


#import "LoginManager.h"
#import "MLLoginVC.h"

@implementation LoginManager

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
    alertView.tag=settingsAlertTag;
    [alertView show];
}


-(void)notLoginHandler
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"还未登录，请先登录" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"马上去", nil];
    alertView.tag=loginAlertTag;
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case loginAlertTag:
        {
            if (buttonIndex==selectOK) {
                MLNaviViewController *navi=[[MLNaviViewController alloc]initWithRootViewController:[MLLoginVC sharedInstance]];
                [self.delegate presentViewModally:navi];
            }
            break;
        }
        case settingsAlertTag:
        {
            if (buttonIndex==selectOK) {
               
                ALERT(@"设置资料");
        
                
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
