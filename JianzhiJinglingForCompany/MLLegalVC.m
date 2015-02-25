//
//  MLLegalVC.m
//  jobSearch
//
//  Created by RAY on 15/2/5.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLegalVC.h"

@interface MLLegalVC ()

@end

@implementation MLLegalVC

static  MLLegalVC *thisVC=nil;
+ (MLLegalVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLLegalVC alloc]init];
    }
    return thisVC;
}

- (void)viewWillLayoutSubviews{
    
    self.title=@"使用协议";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
