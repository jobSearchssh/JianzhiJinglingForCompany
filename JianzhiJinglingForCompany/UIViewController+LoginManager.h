//
//  UIViewController+LoginManager.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoginManager)<UIAlertViewDelegate>
+(BOOL)isLogin;
+(BOOL)isUpLoadComProfile;
-(void)notLoginHandler;
-(void)notSettingprofile;
@end
