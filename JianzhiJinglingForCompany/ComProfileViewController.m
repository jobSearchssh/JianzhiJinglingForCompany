//
//  ComProfileViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "ComProfileViewController.h"
#import "CompanyResumeViewController.h"
#import "enterpriseDetailModel.h"
#import "netAPI.h"
#import "UIViewController+HUD.h"
#import "UIViewController+ErrorHandler.h"
#import "UIViewController+RESideMenu.h"
#import "UIViewController+LoginManager.h"
#import "MLLoginVC.h"
#import "MainTabBarViewController.h"
#import "MLNaviViewController.h"
#import "MBProgressHUD+Add.h"
#import "LoginManager.h"
@interface ComProfileViewController ()<UIAlertViewDelegate>
{
    BOOL isLoadSucceed;
}

@property(nonatomic,strong)enterpriseDetailModel *thisCompany;
@end

@implementation ComProfileViewController


-(void)loadDataFromNet
{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    if (self.thisCompany==nil) {
        [self showHudInView:self.view hint:@"正在加载..."];
        NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
        NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
        [netAPI getEnterpriseDetail:com_id withBlock:^(enterpriseDetailReturnModel *detailModel) {
            [self hideHud];
            if ([[detailModel getStatus]intValue]==BASE_SUCCESS) {
                self.thisCompany=[detailModel getenterpriseDetailModel];
                isLoadSucceed=YES;
                [self loadDataInView];
            }else
            {
                NSString *error=[NSString stringWithFormat:@"%@",[detailModel getInfo]];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:Text_Note message:error delegate:self cancelButtonTitle:Text_CancelBtnText otherButtonTitles:Text_RetryText, nil];
                [alertView show];
            }
        }];
    }
}

-(void)loadDataInView
{   isLoadSucceed=YES;
    self.comName.text=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseName]];
    self.comAddress.text=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseAddressDetail]];
    
    self.comIntro.text=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseIntroduction]];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseIntroduction]]);
    NSLog(@"%@",self.comIntro.text);
    
    NSString *logoUrl=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseLogoURL]];
    NSLog(@"%@",logoUrl);
    if (logoUrl!=nil) {
        if ([logoUrl length]>4) {
            if ([[logoUrl substringToIndex:4] isEqualToString:@"http"]){
                
                self.comImage.contentMode = UIViewContentModeScaleAspectFill;
                self.comImage.clipsToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.comImage];
                self.comImage.imageURL=[NSURL URLWithString:logoUrl];
            }
        }
        [self checkUserStatusForReSideMenu];
    }
    else{
        self.comImage.image=[UIImage imageNamed:@"placeholder"];
    }
    
    //修改NSUserDefaults
    if (self.thisCompany!=nil)
    {
        NSUserDefaults *mysetings=[NSUserDefaults standardUserDefaults];
        NSString *comLogoURL=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseLogoURL]];
        NSString *comIntro=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseIntroduction]];
        NSString *comName=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseName]];
        NSString *comIndusrty=[[[NSNumberFormatter alloc] init]stringFromNumber:[self.thisCompany getenterpriseIndustry]];
        NSString *comAddress=[NSString stringWithFormat:@"%@",[self.thisCompany getenterpriseAddressDetail]];
 
        [mysetings setObject:comLogoURL forKey:CURRENTLOGOURL];
        [mysetings setObject:comName forKey:CURRENTUSERREALNAME];
        [mysetings setObject:comIndusrty forKey:CURRENTUSERINDUSTRY];
        [mysetings setObject:comIntro forKey:CURRENTINTRODUCTION];
        [mysetings setObject:comAddress forKey:CURRENTUSERADDRESS];
        [mysetings setBool:YES forKey:COMPROFILEFlag];
        [mysetings synchronize];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideHud];
    //如果加载成功过，就不要刷新
    if([LoginManager isOrNotSettingComProfile]==NO){
        ALERT(Text_NoCompanyDetail);
        return;
    }
    if (!isLoadSucceed) {
            [self loadDataFromNet];
    }
}

-(void)loadDataFromEditAgain:(NSNotification*)sender
{
    //加载本地
    NSDictionary *dict=[sender userInfo];
    self.thisCompany=[dict objectForKey:@"item"];
    [self loadDataInView];
}


-(void)autoData
{
    if([LoginManager isOrNotSettingComProfile]==NO)
    {
        ALERT(Text_NoCompanyDetail);
        return;
    }
    [self loadDataFromNet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLoadSucceed=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataFromEditAgain:) name:@"资料修改成功" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoData) name:@"autoLoadNearData" object:nil];
    self.title=@"企业信息";
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
    self.comIntro.scrollEnabled= YES;//是否可以拖动
    
    self.comIntro.editable=NO;//禁止编辑
    
    self.comIntro.autoresizingMask= UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
}

-(void)editResume
{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    CompanyResumeViewController *editVC=[[CompanyResumeViewController alloc]init];
    editVC.enterprise=self.thisCompany;
    editVC.hidesBottomBarWhenPushed=YES;
    editVC.isPushedOut=YES;
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [self editResume];
            }
            break;
        }
        default:
            if (buttonIndex==1) {
                [self loadDataFromNet];
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
    
@end
