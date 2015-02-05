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
@implementation UIViewController (RESideMenu)

-(void)addLeftBarItem:(UINavigationController*)targetVC
{
    
    targetVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainItem"] style:UIBarButtonItemStyleBordered target:targetVC action:@selector(showMenu)];
    targetVC.navigationController.navigationBar.translucent = NO;
    
    
}

- (void)showMenu
{
    RESideMenu *_sideMenu=[RESideMenu sharedInstance];
    
    if (!_sideMenu) {
        
        RESideMenuItem *usrItem = [[RESideMenuItem alloc] initWithTitle:@"未登录" setFlag:USRCELL setSubtitle:@"游客"  image:[UIImage imageNamed:@"tourists"] highlightedImage:[UIImage imageNamed:@"avatar_round_m"] action:^(RESideMenu *menu, RESideMenuItem *item){
            
            MLLoginVC *viewController = [MLLoginVC sharedInstance];
            MLNaviViewController *navigationController = [[MLNaviViewController alloc] initWithRootViewController:viewController];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [menu setRootViewController:navigationController];
            
        }];
        
        RESideMenuItem *searchItem = [[RESideMenuItem alloc] initWithTitle:@"搜索" setFlag:NORMALCELL image:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
            //            MLFirstVC *viewController = [MLFirstVC sharedInstance];
            //            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:viewController];
            //            navigationController.navigationBar.translucent = NO;
            //            navigationController.tabBarController.tabBar.translucent = NO;
            //            navigationController.toolbar.translucent = NO;
            //            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:@"关注的求职者" setFlag:NORMALCELL image:[UIImage imageNamed:@"collection"] highlightedImage:[UIImage imageNamed:@"collection"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            PersonListViewController *personVC=[[PersonListViewController alloc]init];
            
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
        
        RESideMenuItem *dailymatchItem = [[RESideMenuItem alloc] initWithTitle:@"精灵匹配" setFlag:NORMALCELL image:[UIImage imageNamed:@"calendar"] highlightedImage:[UIImage imageNamed:@"calendar"] action:^(RESideMenu *menu, RESideMenuItem *item)  {
            [menu hide];
            MLMatchVC *forthVC=[[MLMatchVC alloc]init];
            
            [self addLeftBarItem:forthVC];
             MLNaviViewController *navigationVC=[[MLNaviViewController alloc]initWithRootViewController:forthVC];
            [menu setRootViewController:navigationVC];
        }];
        
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:@"发送反馈" setFlag:NORMALCELL image:[UIImage imageNamed:@"send"] highlightedImage:[UIImage imageNamed:@"send"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"声明" setFlag:NORMALCELL image:[UIImage imageNamed:@"notice"] highlightedImage:[UIImage imageNamed:@"notice"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
                RESideMenuItem *backItem = [[RESideMenuItem alloc] initWithTitle:@"返回首页" setFlag:NORMALCELL image:[UIImage imageNamed:@"logout"] highlightedImage:[UIImage imageNamed:@"logout"] action:^(RESideMenu *menu, RESideMenuItem *item) {
                    NSLog(@"Item %@", item);
                    [menu hide];
                    MainTabBarViewController *mainTab=[MainTabBarViewController shareInstance];
                    
                    [menu setRootViewController:mainTab];
                }];
        
        
        _sideMenu=[RESideMenu initInstanceWithItems:@[usrItem,searchItem, savedItem, applicationItem,dailymatchItem,feedbackItem, aboutusItem,backItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    [_sideMenu show];
}


@end
