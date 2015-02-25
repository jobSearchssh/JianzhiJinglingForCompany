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
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationBar setTitleTextAttributes:titleBarAttributes];
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
