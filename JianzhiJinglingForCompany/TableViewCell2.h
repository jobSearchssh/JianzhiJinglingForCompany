//
//  TableViewCell2.h
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AsyncImageView.h"
@interface TableViewCell2 : SWTableViewCell
@property (strong,nonatomic)NSString *Job_id;
@property (assign,nonatomic)NSInteger row;


@property (weak, nonatomic) IBOutlet AsyncImageView *jobImageView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobUpdateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recruitNumLabel;

-(void)setJobImageViewWithJsBadgeNSString:(NSString*) badgeString;
@end
