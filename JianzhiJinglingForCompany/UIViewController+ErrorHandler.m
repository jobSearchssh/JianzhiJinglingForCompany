//
//  UIViewController+ErrorHandler.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "UIViewController+ErrorHandler.h"
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"
@implementation UIViewController (ErrorHandler)
-(void)timeout
{
    [self hideHud];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"请求超时" toView:self.view];
}
@end
