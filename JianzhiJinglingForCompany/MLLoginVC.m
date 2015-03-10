//
//  MLLoginVC.m
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#define LogoutAlertViewTag 90101
#define RegistAlertViewTag 90102


#import "MLLoginVC.h"
#import "QCheckBox.h"
#import "MLLoginBusiness.h"
#import "SMS_SDK/SMS_SDK.h"
#import "UIViewController+RESideMenu.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIViewController+ErrorHandler.h"
#import "RESideMenu.h"
#import "forgetPasswordVC.h"
#import "MLLegalVC.h"
#import "BadgeManager.h"
@interface MLLoginVC ()<QCheckBoxDelegate,loginResult,registerResult,UIGestureRecognizerDelegate,UIAlertViewDelegate,UINavigationBarDelegate>{
    
    UIButton *chooseLoginBtn;
    UIButton *chooseRegisterBtn;
    BOOL agree;
    BOOL autoLogin;
    
    BOOL isPushWhenInRegistrationState;
    NSTimer *timer;
    int seconds;
}
@property (strong,nonatomic)MLLoginBusiness *loginer;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *errorAlertLabel;
- (IBAction)disMissBtnAction:(id)sender;


- (IBAction)FindBackPSWAction:(id)sender;

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
        thisVC.loginer=[[MLLoginBusiness alloc]init];
        thisVC.loginer.loginResultDelegate=thisVC;
        thisVC.loginer.registerResultDelegate=thisVC;
    }
    return thisVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    isPushWhenInRegistrationState=NO;
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    //监听登出成功接口
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccessAction) name:@"logoutSuccess"object:nil];
    
    
//    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [self.navigationItem setTitle:@"兼职精灵企业版"];
     UIBarButtonItem *closeButton=[[UIBarButtonItem
                                    alloc]initWithTitle:@"  返回"  style:UIBarButtonItemStylePlain target:self action:@selector(disMissBtnAction:)];
    
    [closeButton setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:closeButton];
    
    
    chooseLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width/2, 44)];
    chooseLoginBtn.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [chooseLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [chooseLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [chooseLoginBtn addTarget:self action:@selector(chooseLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseLoginBtn];
    
    chooseRegisterBtn=[[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, 64, [[UIScreen mainScreen] bounds].size.width/2, 44)];
    chooseRegisterBtn.backgroundColor=[UIColor darkGrayColor];
    [chooseRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseRegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [chooseRegisterBtn addTarget:self action:@selector(chooseRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseRegisterBtn];
    
    if ([[UIScreen mainScreen] bounds].size.height!=480) {
        self.loginView.frame=CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 220);
        self.registerView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 40, [[UIScreen mainScreen] bounds].size.width, 330);
    }else{
        self.loginView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 220);
        self.registerView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, 330);
    }
    
    
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
    
    self.sendMsgButtonLabel.backgroundColor=[UIColor clearColor];
    self.sendMsgButtonLabel.backgroundColor =[UIColor lightGrayColor];
    
}

//-(void)viewWillLayoutSubviews
//{
//
//    self.loginView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 220);
//    self.registerView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, 330);
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.loginView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 220);
//    self.registerView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, 330);
//    [self checkLoginStatus];
    if (isPushWhenInRegistrationState) {
        [self chooseRegister];
        isPushWhenInRegistrationState=NO;
        return;
    }
    [self chooseLogin];
}

-(void)checkLoginStatus
{
    //检查登陆模式、和自动填充
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *username=[mySettingData objectForKey:CURRENTUSERNAME];
    if (username!=nil) {
        self.loginButton.hidden=NO;
        self.logoutBtn.hidden=YES;
        self.userAccount.text=username;
        self.userPassword.text=@"******";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=LogoutAlertViewTag;
        [alert show];
    }else
    {
        self.loginButton.hidden=NO;
        self.logoutBtn.hidden=YES;
    }

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
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
}

- (void)chooseRegister{
    chooseLoginBtn.backgroundColor=[UIColor darkGrayColor];
    chooseRegisterBtn.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [chooseRegisterBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [chooseLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, self.scrollView.contentOffset.y) animated:YES];
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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CURRENTUSERID]!=nil) {
        [MBProgressHUD showError:Text_LoginOverdone toView:self.view];
        return;
    }
    [self.userPassword resignFirstResponder];
    if ([inputUserAccount length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_Note message:Text_InputPhone delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
        [alert show];
    }else if ([inputUserPassword length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_InputPwd message:nil delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
        [alert show];
    }else{
        if (!self.loginer) {
            self.loginer=[[MLLoginBusiness alloc]init];
            self.loginer.loginResultDelegate=self;
        }
        [self showHudInView:self.view hint:Text_Logining];
        [self.loginer loginInBackground:inputUserAccount Password:inputUserPassword];
    }
}


#pragma --mark 登录成功返回 delegate接口
- (void)loginResult:(BOOL)isSucceed Feedback:(NSString*)feedback{
    [self hideHud];
    if (isSucceed) {
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        if ([mySettingData objectForKey:CURRENTUSERNAME]) {
            NSString *currentUsrName=[mySettingData objectForKey:CURRENTUSERNAME];
            RESideMenu* _sideMenu=[RESideMenu sharedInstance];
            NSString *Urlstring=nil;
            if ([mySettingData objectForKey:CURRENTLOGOURL]) {
                Urlstring=[mySettingData objectForKey:CURRENTLOGOURL];
            }
            [_sideMenu setTableItem:0 Title:currentUsrName Subtitle:@"点击退出" ImageUrl:Urlstring];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_LoginSucess message:nil delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:^{
            [self checkUserStatusForReSideMenu];
    
            [[NSNotificationCenter defaultCenter]postNotificationName:@"autoLoadNearData" object:nil];
            [[BadgeManager shareSingletonInstance]refreshCount];
            if (![mySettingData objectForKey:CURRENTLOGOURL]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"notSettingprofile" object:nil];
                
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_LoginFail message:feedback delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
        [alert show];
    }
}
#pragma --mark 注册成功返回 delegate接口
- (void)registerResult:(BOOL)isSucceed Feedback:(NSString *)feedback{
    [self hideHud];
    if (isSucceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_RegistSuccess message:nil delegate:self cancelButtonTitle:Text_LoginWait otherButtonTitles:Text_LoginImd,nil];
        alert.tag=RegistAlertViewTag;
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_RegistFail message:feedback delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)phoneEditingChanged:(id)sender {
    if(self.phoneNumber.text.length==11)
    {
        [self stopTimerAndResetBtn];
        inputUserPhoneNumber=_phoneNumber.text;
        self.sendMsgButton.enabled=YES;
        [self.sendMsgButtonLabel setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
        
    }else{
        inputUserPhoneNumber=nil;
        self.sendMsgButton.enabled=NO;
        [self.sendMsgButtonLabel setBackgroundColor:[UIColor lightGrayColor]];
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
    [self.userPassword2 resignFirstResponder];
    [self checkFinishedInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMassage:(id)sender {
    [self showHudInView:self.view hint:Text_Sending];
    [SMS_SDK getVerifyCodeByPhoneNumber:inputUserPhoneNumber AndZone:Num_TelephonePrefixZone result:^(enum SMS_GetVerifyCodeResponseState state) {
        [self hideHud];
        if (1==state) {
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            [MBProgressHUD showSuccess:Text_SendedVMS toView:self.view];
            
            verifiedPhoneNumber=inputUserPhoneNumber;
        }
        else if(0==state)
        {
            [MBProgressHUD showError:Text_VMSFail toView:self.view];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            [MBProgressHUD showError:Text_VMSOverLimits toView:self.view];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
           [MBProgressHUD showError:Text_VMSOperationInvailed toView:self.view];
        }
    }];
}

-(void)initTimer
{
    [self.sendMsgButtonLabel setText:[NSString stringWithFormat:@"%ds",60] ];
    self.sendMsgButton.enabled=NO;
    [self.sendMsgButtonLabel setBackgroundColor:[UIColor lightGrayColor]];
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
    if (seconds==0) {
        [self performSelectorOnMainThread:@selector(showTimerWhenTimeOut) withObject:nil waitUntilDone:YES];
    }
    else{
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:NO];
    }
}


-(void)stopTimerAndResetBtn
{
    [timer invalidate];
    [self.sendMsgButtonLabel setText:Text_SendVMSBtnText];
    self.sendMsgButton.enabled=YES;
    [self.sendMsgButtonLabel setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    seconds=60;
}

-(void)showTimerWhenTimeOut
{
    [timer invalidate];
    [self.sendMsgButtonLabel setText:Text_SendVMSBtnText];
    self.sendMsgButton.enabled=YES;
    [self.sendMsgButtonLabel setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    seconds=60;
}

- (void)showTimer{
    [self.sendMsgButtonLabel setText:[NSString stringWithFormat:@"%ds",seconds] ];
    if (seconds==0) {
        [timer invalidate];
        [self.sendMsgButtonLabel setText:Text_SendVMSBtnText];
        self.sendMsgButton.enabled=YES;
        [self.sendMsgButtonLabel setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
        seconds=60;
    }
}

- (void)startRegisting{
    
    [SMS_SDK commitVerifyCode:inputSecurityCode result:^(enum SMS_ResponseState state) {
        if (1==state) {
            if (!self.loginer) {
                self.loginer=[[MLLoginBusiness alloc]init];
                self.loginer.registerResultDelegate=self;
            }
            [self showHudInView:self.view hint:Text_Registing];
            [self.loginer registerInBackground:inputUserPhoneNumber Password:inputUserPassword2];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_VMSError message:nil delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)checkFinishedInput{
    if ([inputUserPhoneNumber length]==11&&[inputSecurityCode length]>0&&[inputUserPassword1 isEqualToString:inputUserPassword2]&&agree&&[inputUserPhoneNumber isEqualToString:verifiedPhoneNumber]) {
        [self startRegisting];
    }else{
        NSString*alertString=@"";
        
        if (inputUserPhoneNumber.length!=11) {
            alertString=[alertString stringByAppendingString:Text_PhoneError];
        }
        else if ([inputSecurityCode length]==0) {
            alertString=[alertString stringByAppendingString:Text_VMSMissed];
        }
        else if (![inputUserPassword1 isEqualToString:inputUserPassword2]) {
            alertString=[alertString stringByAppendingString:Text_PWDNotComfirm];
        }
        else if (!agree){
            alertString=[alertString stringByAppendingString:Text_ProtocolNotAgree];
        }
        else if (verifiedPhoneNumber==nil || ![inputUserPhoneNumber isEqualToString:verifiedPhoneNumber])
        {
           alertString=[alertString stringByAppendingString:Text_VMSObsolete];
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
        [MBProgressHUD showError:alertString toView:self.view];
    }
    
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case LogoutAlertViewTag:
            if(buttonIndex==0)
            {
//                self.logoutBtn.hidden=NO;
//                self.loginButton.hidden=YES;
            
            }
            if (buttonIndex==1) {
                [self logoutBtnAction:nil];
            }
            break;
            
        case RegistAlertViewTag:
            if (buttonIndex==1) {
                [self showHudInView:self.view hint:Text_Logining];
                [self.loginer loginInBackground:inputUserPhoneNumber Password:inputUserPassword2];
            }else if(buttonIndex==0)
            {
                [self chooseLogin];
            }
            break;
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

- (IBAction)logoutBtnAction:(id)sender {
    inputUserAccount=_userAccount.text;
    //退出逻辑
    [MLLoginBusiness logout];
    self.userPassword.text=nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_Note message:Text_logoutSuccess delegate:nil cancelButtonTitle:Text_GetKnownText otherButtonTitles:nil];
    [alert show];
}

- (IBAction)readLegalStatementAction:(id)sender {
    MLLegalVC *VC=[MLLegalVC sharedInstance];
    VC.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController pushViewController:VC animated:YES];
    isPushWhenInRegistrationState=YES;
}

- (IBAction)disMissBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logoutSuccessAction
{
//更新UI



}
- (IBAction)FindBackPSWAction:(id)sender {
    
    forgetPasswordVC *vc=[[forgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
