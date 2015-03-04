//
//  TableViewCell.m
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

-(JSBadgeView *)badgeView
{
    if (_badgeView==nil) {
        JSBadgeView *badgeView=[[JSBadgeView alloc]initWithParentView:self.usrImage alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText=nil;
        _badgeView=badgeView;

    }
    return _badgeView;
}
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
