//
//  MLLoginVC.m
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLoginVC.h"
#import "QCheckBox.h"
#import "MLLoginBusiness.h"
#import "SMS_SDK/SMS_SDK.h"

@interface MLLoginVC ()<QCheckBoxDelegate,loginResult,registerResult,UIGestureRecognizerDelegate>{
    
    UIButton *chooseLoginBtn;
    UIButton *chooseRegisterBtn;
    MLLoginBusiness *loginer;
    BOOL agree;
    BOOL autoLogin;
    
    NSTimer *timer;
    int seconds;
}

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *errorAlertLabel;

@end

@implementation MLLoginVC
@synthesize userAccount=_userAccount;
@synthesize userPassword=_userPassword;
@synthesize phoneNumber=_phoneNumber;
@synthesize securityCode=_securityCode;
@synthesize userPassword1=_userPassword1;
@synthesize userPassword2=_userPassword2;


static  MLLoginVC *thisVC=nil;

+ (MLLoginVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLLoginVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    chooseLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/2, 44)];
    chooseLoginBtn.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [chooseLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [chooseLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [chooseLoginBtn addTarget:self action:@selector(chooseLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseLoginBtn];
    
    chooseRegisterBtn=[[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, 0, [[UIScreen mainScreen] bounds].size.width/2, 44)];
    chooseRegisterBtn.backgroundColor=[UIColor darkGrayColor];
    [chooseRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseRegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [chooseRegisterBtn addTarget:self action:@selector(chooseRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseRegisterBtn];
    
    
    self.loginView.frame=CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, 220);
    self.registerView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 44, [[UIScreen mainScreen] bounds].size.width, 330);
    
    //for check box
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.tag=1;
    _check1.frame = CGRectMake(25, 120, 25, 25);
    [_check1 setTitle:nil forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.loginView addSubview:_check1];
    [_check1 setChecked:YES];
    
    QCheckBox *_check2 = [[QCheckBox alloc] initWithDelegate:self];
    _check2.tag=2;
    _check2.frame = CGRectMake(25, 221, 25, 25);
    [_check2 setTitle:nil forState:UIControlStateNormal];
    [_check2 setTitleColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_check2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.registerView addSubview:_check2];
    [_check2 setChecked:YES];
    
    [self.scrollView addSubview:self.loginView];
    [self.scrollView addSubview:self.registerView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRegisnFirstRespond)];
    [self.scrollView addGestureRecognizer:tap];
    
    _phoneNumber.keyboardType=UIKeyboardTypeNumberPad;
    _securityCode.keyboardType=UIKeyboardTypeNumberPad;
    
    agree=YES;
    autoLogin=NO;
    
    self.errorAlertLabel.hidden=YES;
    self.sendMsgButton.enabled=NO;
    
    [self.sendMsgButton setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    
    if (checkbox.tag==1) {
        autoLogin=checked;
    }
    else if (checkbox.tag==2) {
        agree=checked;
    }
}

- (void)chooseLogin{
    chooseLoginBtn.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [chooseLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    chooseRegisterBtn.backgroundColor=[UIColor darkGrayColor];
    [chooseRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)chooseRegister{
    chooseLoginBtn.backgroundColor=[UIColor darkGrayColor];
    chooseRegisterBtn.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [chooseRegisterBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [chooseLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.scrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
}

- (void)tapRegisnFirstRespond{
    
    [_userAccount resignFirstResponder];
    [_userPassword resignFirstResponder];
    [_userPassword1 resignFirstResponder];
    [_userPassword2 resignFirstResponder];
    [_phoneNumber resignFirstResponder];
    [_securityCode resignFirstResponder];
}


- (IBAction)accountEditingChanged:(id)sender {
    inputUserAccount=_userAccount.text;
}

- (IBAction)passwordEditingChanged:(id)sender {
    inputUserPassword=_userPassword.text;
}

- (IBAction)touchLoginBtn:(id)sender {
    if ([inputUserAccount length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号码或账户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if ([inputUserPassword length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登陆密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        
        if (!loginer) {
            loginer=[[MLLoginBusiness alloc]init];
            loginer.loginResultDelegate=self;
            [loginer loginInBackground:inputUserAccount Password:inputUserPassword];
        }
    }
}

- (void)loginResult:(BOOL)isSucceed Feedback:(NSString*)feedback{
    if (isSucceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)registerResult:(BOOL)isSucceed Feedback:(NSString *)feedback{
    if (isSucceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)phoneEditingChanged:(id)sender {
    if(self.phoneNumber.text.length==11)
    {
        inputUserPhoneNumber=_phoneNumber.text;
        self.sendMsgButton.enabled=YES;
        [self.sendMsgButton setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
        
    }else{
        inputUserPhoneNumber=nil;
        self.sendMsgButton.enabled=NO;
        [self.sendMsgButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (IBAction)securitycodeEditingChanged:(id)sender {
    inputSecurityCode=_securityCode.text;
}

- (IBAction)password1EditingChanged:(id)sender {
    inputUserPassword1=_userPassword1.text;
}

- (IBAction)password2EditingChanged:(id)sender {
    inputUserPassword2=_userPassword2.text;
}
- (IBAction)password2EditingEnd:(id)sender {
    
    if (![inputUserPassword1 isEqualToString:inputUserPassword2]) {
        self.errorAlertLabel.hidden=NO;
    }else {
        self.errorAlertLabel.hidden=YES;
    }
}

- (IBAction)touchRegister:(id)sender {
    [self checkFinishedInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMassage:(id)sender {
    [SMS_SDK getVerifyCodeByPhoneNumber:inputUserPhoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码获取失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码申请次数超限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起，你的操作太频繁啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void)initTimer
{
    [self.sendMsgButton setTitle:[NSString stringWithFormat:@"%d秒",60] forState:UIControlStateNormal];
    self.sendMsgButton.enabled=NO;
    [self.sendMsgButton setBackgroundColor:[UIColor lightGrayColor]];
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=60;
    [[NSRunLoop currentRunLoop] run];
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    NSLog(@"%d",seconds);
    seconds--;
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:YES];
    
}

- (void)showTimer{
    [self.sendMsgButton setTitle:[NSString stringWithFormat:@"%d秒",seconds] forState:UIControlStateNormal];
    if (seconds==0) {
        [timer invalidate];
        [self.sendMsgButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
        self.sendMsgButton.enabled=YES;
        [self.sendMsgButton setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
        seconds=60;
    }
}

- (void)startRegisting{
    
    [SMS_SDK commitVerifyCode:inputSecurityCode result:^(enum SMS_ResponseState state) {
        if (1==state) {
            if (!loginer) {
                loginer=[[MLLoginBusiness alloc]init];
                loginer.registerResultDelegate=self;
            }
            [loginer registerInBackground:inputUserPhoneNumber Password:inputUserPassword2];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)checkFinishedInput{
    if ([inputUserPhoneNumber length]==11&&[inputSecurityCode length]>0&&[inputUserPassword1 isEqualToString:inputUserPassword2]&&agree) {
        [self startRegisting];
    }else{
        NSString*alertString;
        
        if (inputUserPhoneNumber.length!=11) {
            [alertString stringByAppendingString:@"手机号码不正确\n"];
        }
        if ([inputSecurityCode length]==0) {
            [alertString stringByAppendingString:@"请输入手机验证码\n"];
        }
        if (![inputUserPassword1 isEqualToString:inputUserPassword2]) {
            [alertString stringByAppendingString:@"两次输入密码不一致\n"];
        }
        if (!agree){
            [alertString stringByAppendingString:@"您没有同意用户使用协议\n"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息填写有误" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
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
