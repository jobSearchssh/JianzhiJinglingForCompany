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
#import "MLNaviViewController.h"
@interface ComProfileViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)enterpriseDetailModel *thisCompany;
@end

@implementation ComProfileViewController


-(void)loadDataFromNet
{
    if (self.thisCompany==nil) {
        [self showHudInView:self.view hint:@"正在加载..."];
        NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
        NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
        [netAPI getEnterpriseDetail:com_id withBlock:^(enterpriseDetailReturnModel *detailModel) {
            [self hideHud];
            if ([[detailModel getStatus]intValue]==BASE_SUCCESS) {
                
                self.thisCompany=[detailModel getenterpriseDetailModel];
                [self loadDataInView];
            }else
            {
                NSString *error=[NSString stringWithFormat:@"%@",[detailModel getInfo]];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"加载失败，是否重试？" message:error delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertView show];
            }
        }];
    }
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (![UIViewController isLogin]) {
//        [self notLoginHandler];
//    }
//}


-(void)loadDataInView
{
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


-(void)loadDataFromNetAgain
{
    self.thisCompany=nil;
    [self loadDataFromNet];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataFromNetAgain) name:@"资料修改成功" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
    self.comIntro.scrollEnabled= YES;//是否可以拖动
    
    self.comIntro.editable=NO;//禁止编辑
    
    self.comIntro.autoresizingMask= UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
    }
    [self loadDataFromNet];
}

-(void)editResume
{
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
