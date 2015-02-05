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
#import "jobPublicationViewController.h"
#import "MLMatchVC.h"
#import "TabbarForthViewController.h"
#import "UIViewController+RESideMenu.h"

@interface MainTabBarViewController ()
{
    NSArray  *_vcArray;
}
@end

@implementation MainTabBarViewController



static MainTabBarViewController* thisVC=nil;

+(MainTabBarViewController*)shareInstance
{
    if (thisVC==nil) {
        thisVC=[[MainTabBarViewController alloc]init];
    }
    return thisVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tabBar setBackgroundColor:TabBarColor];
    // Do any additional setup after loading the view from its nib.
    //设置颜色
    [self.tabBar setBarTintColor:TabBarColor];

    [self initViewControllers];
    
    [self modifyTabbarItem];
    
   
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainItem"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
//    self.navigationItem.translucent = NO;

}

-(void)addLeftBarItem:(UINavigationController*)targetVC
{
    
    targetVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainItem"] style:UIBarButtonItemStyleBordered target:targetVC action:@selector(showMenu)];
    targetVC.navigationController.navigationBar.translucent = NO;
    
    
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
    MLMessageVC *secondVC=[[MLMessageVC alloc]init];
    
    [self addLeftBarItem:secondVC];
    MLNaviViewController *secondNaviVC=[[MLNaviViewController alloc]initWithRootViewController:secondVC];
    
    
    //第三个页面
    
    jobPublicationViewController *thirdVC=[[jobPublicationViewController alloc]init];
    
    [self addLeftBarItem:thirdVC];
    
    MLNaviViewController *thirdNaviVC=[[MLNaviViewController alloc]initWithRootViewController:thirdVC];
    
    //第四个页面
    
     MLMatchVC *forthVC=[[MLMatchVC alloc]init];
    
    [self addLeftBarItem:forthVC];
    
    MLNaviViewController *forthNaviVC=[[MLNaviViewController alloc]initWithRootViewController:forthVC];
    
    //第五个页面
     TabbarForthViewController *fifthVC=[[TabbarForthViewController alloc]init];
    
    [self addLeftBarItem:fifthVC];
     MLNaviViewController *fifthNaviVC=[[MLNaviViewController alloc]initWithRootViewController:fifthVC];
    
    self.viewControllers=@[firstNavi,secondNaviVC,thirdNaviVC,forthNaviVC,fifthNaviVC];
    
    _vcArray=self.viewControllers;
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
    
    tabBarItem5.title=@"更多";
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







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
