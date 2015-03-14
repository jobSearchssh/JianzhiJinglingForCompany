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

+(BOOL)isOrNotLogin
{
    NSUserDefaults *mySetting=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySetting objectForKey:CURRENTUSERID];
    if (com_id!=nil) {
        return YES;
    }
    return NO;
}


+(BOOL)isOrNotSettingComProfile
{
    NSUserDefaults *mySetting=[NSUserDefaults standardUserDefaults];
    BOOL comProfileflag=[mySetting boolForKey:COMPROFILEFlag];
    if (comProfileflag) {
        return YES;
    }
    return NO;
}


-(void)noProfileHandler
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:Text_Note message:Text_NotSettingProfileNote delegate:self cancelButtonTitle:Text_CancelBtnText otherButtonTitles:Text_OK, nil];
    alertView.tag=settingsAlertTag;
    [alertView show];
}


-(void)unLoginHandler
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:Text_NotLogin delegate:self cancelButtonTitle:Text_CancelBtnText otherButtonTitles:Text_ConfirmBrntext, nil];
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
            }
            break;
        }
        default:
            break;
    }
    
    
}



@end
