//
//  UIViewController+ErrorHandler.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//
#ifndef TIMEOUT
#define TIMEOUT 20
#endif
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface UIViewController (ErrorHandler)
-(void)timeout;
@end
