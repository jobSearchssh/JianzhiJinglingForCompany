//
//  TableViewCell2.h
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface TableViewCell2 : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jobImageView;


-(void)setJobImageViewWithJsBadgeNSString:(NSString*) badgeString;
@end
