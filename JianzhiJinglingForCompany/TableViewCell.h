//
//  TableViewCell.h
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AsyncImageView.h"
#import "JSBadgeView.h"
@interface TableViewCell : SWTableViewCell

@property (strong,nonatomic)NSString *userId;
@property(strong,nonatomic)NSIndexPath *index;

@property (strong,nonatomic)JSBadgeView *badgeView;

@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet AsyncImageView *usrImage;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usrJobReq;
@property (weak, nonatomic) IBOutlet UILabel *usrBreifIntro;

@end
