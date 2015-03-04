//
//  forgetPasswordVC.m
//  jobSearch
//
//  Created by RAY on 15/2/27.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "forgetPasswordVC.h"
#import "SMS_SDK/SMS_SDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MLLoginBusiness.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface forgetPasswordVC ()<UITextFieldDelegate,resetPasswordResult,UIAlertViewDelegate,resetPasswordResult>
{

    NSString *inputUserPhoneNumber;
    NSString *inputSecurityCode;
    NSString *inputUserPassword1;
    NSString *inputUserPassword2;
    
    NSString *verifiedPhoneNumber;
    NSTimer *timer;
    int seconds;
    
    MLLoginBusiness *loginer;
    
}
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *userPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *securityCode;
@property (strong, nonatomic) IBOutlet UITextField *userPassword1;
@property (strong, nonatomic) IBOutlet UITextField *userPassword2;
@property (strong, nonatomic) IBOutlet UIButton *sendMsgButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UILabel *errorAlertLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeCountLabel;

@end

@implementation forgetPasswordVC
@synthesize userPhoneNumber=_userPhoneNumber;
@synthesize userPassword1=_userPassword1;
@synthesize userPassword2=_userPassword2;
@synthesize securityCode=_securityCode;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.view1.frame=CGRectMake(0, 12, [[UIScreen mainScreen] bounds].size.width, 220);
    [self.scrollView addSubview:self.view1];
    
    self.view2.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 12, [[UIScreen mainScreen] bounds].size.width, 330);
    [self.scrollView addSubview:self.view2];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRegisnFirstRespond)];
    [self.scrollView addGestureRecognizer:tap];
    
    //增加上移效果
//    [_userPhoneNumber addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
//    [_securityCode addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
//    [_userPassword1 addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
//    [_userPassword2 addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];

    //增加代理
    _userPhoneNumber.delegate = self;
    _securityCode.delegate = self;
    _userPassword1.delegate = self;
    _userPassword2.delegate = self;
    
    _userPhoneNumber.keyboardType=UIKeyboardTypeNumberPad;
    _securityCode.keyboardType=UIKeyboardTypeNumberPad;
    
    self.errorAlertLabel.hidden=YES;
    self.sendMsgButton.enabled=NO;
    self.timeCountLabel.hidden=YES;
    [self.sendMsgButton setBackgroundColor:[UIColor lightGrayColor]];
    
        
    if (!loginer) {
        loginer=[[MLLoginBusiness alloc]init];
        loginer.resetResultDelegate=self;
    }
}

#pragma --mark 找回密码成功返回 delegate接口
- (void) resetPassword:(BOOL)isSucceed Feedback:(NSString *)feedback
{
    [self hideHud];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (isSucceed) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"密码设置成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=1;
        [alertView show];
    }else{
        [MBProgressHUD showError:feedback toView:self.view];
    }
}

- (void)tapRegisnFirstRespond{
    [_userPhoneNumber resignFirstResponder];
    [_securityCode resignFirstResponder];
    [_userPassword1 resignFirstResponder];
    [_userPassword2 resignFirstResponder];
    [self scollToBase];
}

-(void)scollToBase{
    int page;
    if ([self.scrollView contentOffset].x >0) {
        page = 1;
    }else{
        page = 0;
    }
    CGPoint offset = CGPointMake(page*[UIScreen mainScreen].bounds.size.width,0);
    [self.scrollView setContentOffset:offset animated:YES];
}

//编辑上移
-(void)textFieldOutletWork:(UITextField *)sender{
    int page;
    if ([self.scrollView contentOffset].x >0) {
        page = 1;
    }else{
        page = 0;
    }
    CGPoint offset;
    switch (page) {
        case 0:
            offset = CGPointMake(0,sender.frame.origin.y-_userPhoneNumber.frame.origin.y);
            break;
        case 1:
            offset = CGPointMake([UIScreen mainScreen].bounds.size.width,sender.frame.origin.y-_userPassword1.frame.origin.y);
            break;
        default:
            offset = CGPointMake(0,0);
            break;
    }
    [self.scrollView setContentOffset:offset animated:YES];
}

//textfield上移
//响应回车
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    [self scollToBase];
    return YES;
}

- (IBAction)sendMessage:(id)sender {
    
    [self showHudInView:self.view hint:@"正在发送.."];
    [SMS_SDK getVerifyCodeByPhoneNumber:inputUserPhoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        [self hideHud];
        if (1==state) {
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            [MBProgressHUD showSuccess:@"验证码已发送" toView:self.view];
            
            verifiedPhoneNumber=inputUserPhoneNumber;
        }
        else if(0==state)
        {
            [MBProgressHUD showError:@"验证码获取失败" toView:self.view];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            [MBProgressHUD showError:@"验证码申请次数超限" toView:self.view];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            [MBProgressHUD showError:@"对不起，你的操作太频繁啦" toView:self.view];
        }
    }];
}

-(void)initTimer
{
    self.timeCountLabel.hidden=NO;
    self.timeCountLabel.text=[NSString stringWithFormat:@"%d秒",60];
    self.sendMsgButton.hidden=YES;
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=60;
    [[NSRunLoop currentRunLoop] run];
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    seconds--;
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:NO];
}

- (void)showTimer{
    self.timeCountLabel.text=[NSString stringWithFormat:@"%d秒",seconds];
    
    if (seconds==0) {
        [timer invalidate];
        self.sendMsgButton.hidden=NO;
        self.sendMsgButton.enabled=YES;
        self.timeCountLabel.hidden=YES;
        [self.sendMsgButton setBackgroundColor:[UIColor colorWithRed:0.06 green:0.28 blue:0.73 alpha:1.0]];
        seconds=60;
    }
}

- (IBAction)touchOK:(id)sender {
    
    if ([inputUserPassword1 isEqualToString:inputUserPassword2]&&[inputUserPhoneNumber length]==11) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [loginer resetPasswordInBackground:inputUserPhoneNumber Password:inputUserPassword1];
    }
    else{
        [MBProgressHUD showError:@"两次输入的密码不一致" toView:self.view];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)phoneEditingChanged:(id)sender {

    if(self.userPhoneNumber.text.length==11)
    {
        inputUserPhoneNumber= _userPhoneNumber.text;
        self.sendMsgButton.enabled=YES;
        [self.sendMsgButton setBackgroundColor:[UIColor colorWithRed:0.06 green:0.28 blue:0.73 alpha:1.0]];
    }else{
        inputUserPhoneNumber=nil;
        self.sendMsgButton.enabled=NO;
        [self.sendMsgButton setBackgroundColor:[UIColor lightGrayColor]];
    }

}

- (IBAction)verifyCodeChanged:(id)sender {
    inputSecurityCode=_securityCode.text;
}
- (IBAction)password1Changed:(id)sender {
    inputUserPassword1=_userPassword1.text;
}
- (IBAction)password2Changed:(id)sender {
    inputUserPassword2=_userPassword2.text;
}
- (IBAction)password2EndEditing:(id)sender {
    if (![inputUserPassword1 isEqualToString:inputUserPassword2]) {
        self.errorAlertLabel.hidden=NO;
    }else {
        self.errorAlertLabel.hidden=YES;
    }
}
- (IBAction)touchNext:(id)sender {
    
    if ([inputUserPhoneNumber length]==11&&[inputSecurityCode length]>0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [SMS_SDK commitVerifyCode:inputSecurityCode result:^(enum SMS_ResponseState state) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (1==state) {
                CGPoint offset = CGPointMake([UIScreen mainScreen].bounds.size.width,0);
                [self.scrollView setContentOffset:offset animated:YES];
            }
            else if(0==state)
            {
                [MBProgressHUD showError:@"验证码错误" toView:self.view];
            }
        }];
    }
    else{
        [MBProgressHUD showError:@"请输入正确的手机号和验证码" toView:self.view];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
