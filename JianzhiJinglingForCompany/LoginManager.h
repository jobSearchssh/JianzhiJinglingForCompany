//
//  LoginManager.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLNaviViewController.h"

@protocol LoginManagerDelegate <NSObject>
@required

-(void)presentViewModally:(UIViewController*)targetVC;

@end
@interface LoginManager : NSObject

@property (weak,nonatomic)id <LoginManagerDelegate> delegate;

+(BOOL)isOrNotLogin;
+(BOOL)isOrNotSettingComProfile;

-(void)unLoginHandler;
-(void)noProfileHandler;



@end
