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
        usrItem.title=@"点击退出";
        if ([username length]>7) {
            usrItem.subtitle=[NSString stringWithFormat:@"%@**%@",[username substringToIndex:3],[username substringFromIndex:([username length]-3)]];
        }else
        {
          usrItem.subtitle=username;
        }
        if (userImageUrl!=nil) {
            [_sideMenu setTableItem:0 Title:usrItem.title Subtitle:usrItem.subtitle ImageUrl:userImageUrl];
        }
    }else
    {
        usrItem.title=@"未登录";
        usrItem.subtitle=@"游客";
        [_sideMenu setTableItem:0 Title:usrItem.title Subtitle:usrItem.subtitle ImageUrl:nil];
    }
}



//初始化侧拉菜单
-(void)initReSideMenu
{
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
    if (!_sideMenu) {
        RESideMenuItem *usrItem = [[RESideMenuItem alloc] initWithTitle:@"未登录" setFlag:USRCELL setSubtitle:@"游客"image:nil imageUrl:nil highlightedImage:[UIImage imageNamed:@"avatar_round_m"] action:^(RESideMenu *menu, RESideMenuItem *item){
            NSLog(@"Item %@", item);
            [menu hide];
            MainTabBarViewController *mainTab=[MainTabBarViewController shareInstance];
            
            [menu setRootViewController:mainTab];
            
            [mainTab showLoginVC];
            
//            MLLoginVC *viewController = [MLLoginVC sharedInstance];
//            [self addLeftBarItem:viewController];
//            MLNaviViewController *navigationController = [[MLNaviViewController alloc] initWithRootViewController:viewController];
//            navigationController.navigationBar.translucent = NO;
//            navigationController.tabBarController.tabBar.translucent = NO;
//            navigationController.toolbar.translucent = NO;
//            [menu setRootViewController:navigationController];
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
        
        RESideMenuItem *backItem = [[RESideMenuItem alloc] initWithTitle:@"首页" setFlag:NORMALCELL image:[UIImage imageNamed:@"logout"] highlightedImage:[UIImage imageNamed:@"logout"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
            MainTabBarViewController *mainTab=[MainTabBarViewController shareInstance];
            
            [menu setRootViewController:mainTab];
        }];
        
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:@"申请人管理" setFlag:NORMALCELL image:[UIImage imageNamed:@"collection"] highlightedImage:[UIImage imageNamed:@"collection"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            PersonListViewController *personVC=[PersonListViewController shareSingletonInstance];
            [self addLeftBarItem:personVC];
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:personVC];
            [menu setRootViewController:navigationVC];
        }];
        RESideMenuItem *applicationItem = [[RESideMenuItem alloc] initWithTitle:@"我的发布" setFlag:NORMALCELL image:[UIImage imageNamed:@"apply"] highlightedImage:[UIImage imageNamed:@"apply"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            JobPublishedListViewController *publishedJobListVC=[[JobPublishedListViewController alloc]init];
            
            
            [self addLeftBarItem:publishedJobListVC];
            
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:publishedJobListVC];
            [menu setRootViewController:navigationVC];
        }];
        
        //        RESideMenuItem *dailymatchItem = [[RESideMenuItem alloc] initWithTitle:@"精灵匹配" setFlag:NORMALCELL image:[UIImage imageNamed:@"calendar"] highlightedImage:[UIImage imageNamed:@"calendar"] action:^(RESideMenu *menu, RESideMenuItem *item)  {
        //            [menu hide];
        //            MLMatchVC *forthVC=[[MLMatchVC alloc]init];
        //
        //            [self addLeftBarItem:forthVC];
        //            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:forthVC];
        //            [menu setRootViewController:navigationVC];
        //        }];
        
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:@"发送反馈" setFlag:NORMALCELL image:[UIImage imageNamed:@"send"] highlightedImage:[UIImage imageNamed:@"send"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLFeedBackVC *feedBack=[MLFeedBackVC sharedInstance];
            [self addLeftBarItem:feedBack];
            
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:feedBack];
            
            [menu setRootViewController:navigationVC];
//            [menu hide];
//            NSLog(@"Item %@", item);
        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"声明" setFlag:NORMALCELL image:[UIImage imageNamed:@"notice"] highlightedImage:[UIImage imageNamed:@"notice"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            MLLegalVC *legalVC=[MLLegalVC sharedInstance];
            [self addLeftBarItem:legalVC];
            MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:legalVC];
            [menu setRootViewController:navigationVC];

        }];
      
        //初始化方法
        _sideMenu=[RESideMenu initInstanceWithItems:@[usrItem,backItem,savedItem, applicationItem,feedbackItem, aboutusItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    [self checkUserStatusForReSideMenu];
    //显示未读消息}
}


- (void)showMenu
{
    [self checkUserStatusForReSideMenu];
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
//    [_sideMenu setBadgeView:3 badgeText:@"7"];
    [_sideMenu show];
}



@end
