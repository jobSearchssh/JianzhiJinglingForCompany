//
//  UIViewController+RESideMenu.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/3/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//
#import "AppDelegate.h"
#import "UIViewController+RESideMenu.h"
#import "MLNaviViewController.h"
#import "RESideMenu.h"
#import "MLLoginVC.h"
#import "PersonListViewController.h"
#import "JobPublishedListViewController.h"
#import "MLMatchVC.h"
#import "MainTabBarViewController.h"

#import "MLLegalVC.h"
#import "MLFeedBackVC.h"
#import "JSBadgeView.h"
#import "BadgeManager.h"
#import "MyInvitedViewController.h"

@implementation UIViewController (RESideMenu)
-(void)addLeftBarItem:(UIViewController*)targetVC
{
    
    targetVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainItem"] style:UIBarButtonItemStyleBordered target:targetVC action:@selector(showMenu)];
    targetVC.navigationController.navigationBar.translucent = NO;
    
    
}

//add by  郭玉宝   用于更新用户登陆信息，username,userImageUrl,loginStatus
-(void)checkUserStatusForReSideMenu
{
    //没有作用
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
    
    RESideMenuItem *usrItem=[_sideMenu.items objectAtIndex:0];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *username=[mySettingData objectForKey:CURRENTUSERNAME];
    //
    NSString *userImageUrl=[mySettingData objectForKey:CURRENTLOGOURL];
    
    if (username!=nil)
    {
        usrItem.subtitle=@"点击退出";
        if ([username length]>7) {
            usrItem.title=username;
        }else
        {
          usrItem.subtitle=username;
        }
        if (userImageUrl!=nil) {
            [_sideMenu setTableItem:0 Title:usrItem.title Subtitle:usrItem.subtitle ImageUrl:userImageUrl];
        }
    }else
    {
        usrItem.title=@"游客";
        usrItem.subtitle=@"未登录";
        [_sideMenu setTableItem:0 Title:usrItem.title Subtitle:usrItem.subtitle ImageUrl:nil];
    }
    
    
}


//显示未读消息
-(void)showUnreadedNum
{
    NSString *sNum=[BadgeManager shareSingletonInstance].messageCount;
      RESideMenu *_sideMenu=[RESideMenu sharedInstance];
    if ([sNum isEqual:@"0"]|| sNum==nil) {
         [_sideMenu setBadgeView:4 badgeText:nil];
        return;
    }else{
    [_sideMenu setBadgeView:4 badgeText:sNum];
    }
}


//初始化侧拉菜单
-(void)initReSideMenu
{
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
    if (!_sideMenu) {
        RESideMenuItem *usrItem = [[RESideMenuItem alloc] initWithTitle:Btn_Tourists setFlag:USRCELL setSubtitle:Btn_NOLogin image:nil imageUrl:nil highlightedImage:[UIImage imageNamed:@"tourists"] action:^(RESideMenu *menu, RESideMenuItem *item){
            NSLog(@"Item %@", item);
            [menu hide];
            
            
            MainTabBarViewController *mainTab=[MainTabBarViewController shareInstance];
            [menu setRootViewController:mainTab];
                  
            [mainTab showLoginVC];
        }];
        
        //        RESideMenuItem *searchItem = [[RESideMenuItem alloc] initWithTitle:@"搜索" setFlag:NORMALCELL image:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search"] action:^(RESideMenu *menu, RESideMenuItem *item) {
        //            [menu hide];
        //            NSLog(@"Item %@", item);
        //            MLFirstVC *viewController = [MLFirstVC sharedInstance];
        //            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:viewController];
        //            navigationController.navigationBar.translucent = NO;
        //            navigationController.tabBarController.tabBar.translucent = NO;
        //            navigationController.toolbar.translucent = NO;
        //            [menu setRootViewController:navigationController];
        //        }];
        
        RESideMenuItem *backItem = [[RESideMenuItem alloc] initWithTitle:Btn_FirstPage setFlag:NORMALCELL image:[UIImage imageNamed:@"home"] highlightedImage:[UIImage imageNamed:@"home"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
            MainTabBarViewController *mainTab=[MainTabBarViewController shareInstance];
            
            [menu setRootViewController:mainTab];
        }];
        
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:Btn_CandidateManager setFlag:NORMALCELL image:[UIImage imageNamed:@"collection"] highlightedImage:[UIImage imageNamed:@"collection"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            PersonListViewController *personVC=[PersonListViewController shareSingletonInstance];
            [self addLeftBarItem:personVC];
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:personVC];
            [menu setRootViewController:navigationVC];
        }];
        RESideMenuItem *applicationItem = [[RESideMenuItem alloc] initWithTitle:Btn_MyJob setFlag:NORMALCELL image:[UIImage imageNamed:@"apply"] highlightedImage:[UIImage imageNamed:@"apply"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            JobPublishedListViewController *publishedJobListVC=[[JobPublishedListViewController alloc]init];
            [self addLeftBarItem:publishedJobListVC];
            
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:publishedJobListVC];
            [menu setRootViewController:navigationVC];
        }];
        
        RESideMenuItem *InvitationItem = [[RESideMenuItem alloc] initWithTitle:Btn_MyInvitation setFlag:NORMALCELL image:[UIImage imageNamed:@"catagory"] highlightedImage:[UIImage imageNamed:@"catagory"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MyInvitedViewController *publishedJobListVC=[MyInvitedViewController shareSingletonInstance];
            [self addLeftBarItem:publishedJobListVC];
            
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:publishedJobListVC];
            [menu setRootViewController:navigationVC];
        }];
        
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:Btn_FeedBack setFlag:NORMALCELL image:[UIImage imageNamed:@"send"] highlightedImage:[UIImage imageNamed:@"send"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLFeedBackVC *feedBack=[MLFeedBackVC sharedInstance];
            [self addLeftBarItem:feedBack];
            
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:feedBack];
            
            [menu setRootViewController:navigationVC];
        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:Btn_Statement setFlag:NORMALCELL image:[UIImage imageNamed:@"notice"] highlightedImage:[UIImage imageNamed:@"notice"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            MLLegalVC *legalVC=[MLLegalVC sharedInstance];
            [self addLeftBarItem:legalVC];
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:legalVC];
            [menu setRootViewController:navigationVC];

        }];
      
        //初始化方法
        _sideMenu=[RESideMenu initInstanceWithItems:@[usrItem,backItem,savedItem, applicationItem,InvitationItem,feedbackItem, aboutusItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    [self checkUserStatusForReSideMenu];
    //显示未读消息}
}


- (void)showMenu
{
    [self checkUserStatusForReSideMenu];
    [self showUnreadedNum];
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
//    [_sideMenu setBadgeView:3 badgeText:@"7"];
    [_sideMenu show];
}



@end
