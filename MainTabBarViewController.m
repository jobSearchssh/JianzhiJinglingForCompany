//
//  MainTabBarViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "MLNaviViewController.h"

#import "FirstCollectionViewController.h"

#import "MLMessageVC.h"
#import "JobPublishedListViewController.h"
#import "MLMatchVC.h"
#import "TabbarForthViewController.h"
#import "UIViewController+RESideMenu.h"

#import "PersonListViewController.h"
#import "jobTemplateListViewController.h"

#import "UIViewController+LoginManager.h"
#import "MLLoginVC.h"
#import "RESideMenu.h"
#import "ComProfileViewController.h"
#import "BadgeManager.h"
@interface MainTabBarViewController ()<UIAlertViewDelegate>

@property (strong,nonatomic)NSArray  *vcArray;
@property (strong,readonly,nonatomic)RESideMenu *sideMenu;

@end

@implementation MainTabBarViewController



static MainTabBarViewController* thisVC=nil;

+(MainTabBarViewController*)shareInstance
{
    if (thisVC==nil) {
        static dispatch_once_t onceToke;
        dispatch_once(&onceToke,^{
            thisVC=[[super alloc]init];
        });
    }
    
    return thisVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.tabBar setBackgroundColor:TabBarColor];
    // Do any additional setup after loading the view from its nib.
    //设置颜色
//    if (![UIViewController isLogin]) {
//        [self notLoginHandler];
//        //        MLLoginVC *viewController = [MLLoginVC sharedInstance];
//        //        [self presentViewController:viewController animated:YES completion:nil];
//    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkUnLoadConProfile) name:@"checkUnLoadConProfile" object:nil];
    
    [[BadgeManager shareSingletonInstance] addObserver:self forKeyPath:@"applyCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    
    
    [self.tabBar setBarTintColor:TabBarColor];
    [self initViewControllers];
    [self modifyTabbarItem];
    [self initReSideMenu];
    //    _sideMenu=[RESideMenu sharedInstance];
}

-(void)checkUnLoadConProfile
{
    if (![UIViewController isUpLoadComProfile]) {
        [self notSettingprofile];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%lu",(unsigned long)[self.vcArray count]);
}

-(void)initViewControllers
{
    
    //第一个页面
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing=CollectionViewMiniLineSpace;
    flowLayout.minimumInteritemSpacing=CollectionViewMiniInterItemsSpace;
    FirstCollectionViewController *firstVC=[[FirstCollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    
    [self addLeftBarItem:firstVC];
    
    MLNaviViewController *firstNavi=[[MLNaviViewController alloc]initWithRootViewController:firstVC];
    //第二个页面
    PersonListViewController *secondVC=[[PersonListViewController alloc]init];
    
    [self addLeftBarItem:secondVC];
    MLNaviViewController *secondNaviVC=[[MLNaviViewController alloc]initWithRootViewController:secondVC];
    //第三个页面
    
    jobTemplateListViewController *thirdVC=[[jobTemplateListViewController alloc]init];
    
    [self addLeftBarItem:thirdVC];
    
    MLNaviViewController *thirdNaviVC=[[MLNaviViewController alloc]initWithRootViewController:thirdVC];
    
    //第四个页面
    
    MLMatchVC *forthVC=[[MLMatchVC alloc]init];
    
    [self addLeftBarItem:forthVC];
    
    MLNaviViewController *forthNaviVC=[[MLNaviViewController alloc]initWithRootViewController:forthVC];
    
    //第五个页面
    ComProfileViewController *fifthVC=[[ComProfileViewController alloc]init];
    
    [self addLeftBarItem:fifthVC];
    MLNaviViewController *fifthNaviVC=[[MLNaviViewController alloc]initWithRootViewController:fifthVC];
    
    self.viewControllers=@[firstNavi,secondNaviVC,thirdNaviVC,forthNaviVC,fifthNaviVC];
    
    self.vcArray=self.viewControllers;
}

-(void)modifyTabbarItem
{
    
    UITabBar *tabBar=self.tabBar;
    tabBar.tintColor=[UIColor whiteColor];
    
    UITabBarItem *tabBarItem1=[tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2=[tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3=[tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4=[tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5=[tabBar.items objectAtIndex:4];
    
    tabBarItem1.title=@"求职者";
    tabBarItem1.image=[UIImage imageNamed:@"userTabbar"];
    
    tabBarItem2.title=@"消息";
    tabBarItem2.image=[UIImage imageNamed:@"letter"];
    tabBarItem3.title=@"发布";
    tabBarItem3.image=[UIImage imageNamed:@"edit"];
    
    tabBarItem4.title=@"精灵管家";
    tabBarItem4.image=[UIImage imageNamed:@"calendar"];
    
    tabBarItem5.title=@"企业信息";
    tabBarItem5.image=[UIImage imageNamed:@"moreTabbar"];
    
    //    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"name"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"name"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //
    //
    //    //
    //    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //
    //    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //
    //    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"notice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"notice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //
    //     [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}


- (void)viewWillLayoutSubviews{
    
    //    [self.tabBar setSelectedImageTintColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showLoginVC
{
    
    //检查登陆模式、和自动填充
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *username=[mySettingData objectForKey:CURRENTUSERNAME];
    if (username!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=123344;
        [alert show];
    }
    else
    {
       //登陆
        MLNaviViewController *navi=[[MLNaviViewController alloc]initWithRootViewController:[MLLoginVC sharedInstance] ];
        
        [self presentViewController:navi animated:YES completion:^{
            
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    UITabBarItem *tabBarItem1=[self.tabBar.items objectAtIndex:1];
    if ([keyPath isEqual:@"applyCount"]) {
        BadgeManager *bn=[BadgeManager shareSingletonInstance];
        if ([bn.applyCount intValue]>0)
        {
            [tabBarItem1 setBadgeValue:[NSString stringWithFormat:@"new"]];
        }
        else
            tabBarItem1.badgeValue=nil;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 123344:
            if (buttonIndex==1) {
                
                MLNaviViewController *navi=[[MLNaviViewController alloc]initWithRootViewController:[MLLoginVC sharedInstance] ];
                
                [self presentViewController:navi animated:YES completion:^{
                     [[MLLoginVC sharedInstance] logoutBtnAction:nil];
                }];
            }
            break;
            
        default:
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
