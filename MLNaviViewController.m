//
//  MLNaviViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "MLNaviViewController.h"
#import "RESideMenu.h"
#import "MLLoginVC.h"
#import "AppDelegate.h"
@interface MLNaviViewController ()

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

@end

@implementation MLNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationBar setBackgroundColor:NaviBarColor];
    //设置Navi 颜色
    [self.navigationBar setBarTintColor:NaviBarColor];
    
    self.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationBar setTitleTextAttributes:titleBarAttributes];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
