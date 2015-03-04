//
//  MLMatchVC.h
//  jobSearch
//
//  Created by RAY on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSplitingManager.h"
@interface MLMatchVC : UIViewController

+ (MLMatchVC*)sharedInstance;
@property (nonatomic,weak)PageSplitingManager *pageManager;
@end
