//
//  UIViewController+RESideMenu.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/3/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface UIViewController (RESideMenu)
-(void)showMenu;
@end
