//
//  loginTableViewCell.h
//  jobSearch
//
//  Created by 田原 on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenuItem.h"
#import "RESideMenu.h"

@interface loginTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *loginOutlet;
@property (weak, nonatomic) IBOutlet UIButton *registerOutlet;
@property (weak, nonatomic) RESideMenuItem *item;
@property (weak, nonatomic) RESideMenu *menu;

@end
