//
//  MLLoginVC.h
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MLLoginVC : UIViewController<UITextFieldDelegate>
{
    NSString *inputUserAccount;
    NSString *inputUserPassword;
    NSString *inputUserPhoneNumber;
    NSString *inputSecurityCode;
    NSString *inputUserPassword1;
    NSString *inputUserPassword2;
    
    NSString *verifiedPhoneNumber;
}
+ (MLLoginVC*)sharedInstance;


@property BOOL isModally;


@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *securityCode;

@property (weak, nonatomic) IBOutlet UITextField *userPassword1;
@property (weak, nonatomic) IBOutlet UITextField *userPassword2;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)logoutBtnAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *sendMsgButton;
@end
