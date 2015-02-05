//
//  TableViewCell2.m
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "TableViewCell2.h"
#import "JSBadgeView.h"
@implementation TableViewCell2


-(void)setJobImageViewWithJsBadgeNSString:(NSString*) badgeString
{
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self.jobImageView alignment:JSBadgeViewAlignmentTopRight];
    if (badgeString==nil) {
        badgeView.badgeText=nil;
        return;
    }
    badgeView.badgeText = badgeString;
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
