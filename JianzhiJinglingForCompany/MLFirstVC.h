//
//  MLFirstVC.h
//  jobSearch
//
//  Created by RAY on 15/1/16.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLFirstVC : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


+ (MLFirstVC*)sharedInstance;

@end
