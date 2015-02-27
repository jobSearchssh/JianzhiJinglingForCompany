//
//  sideNormalTableViewCell.m
//  jobSearch
//
//  Created by 田原 on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "sideNormalTableViewCell.h"

@implementation sideNormalTableViewCell
@synthesize item;
-(void)notifyDatasetChange;
{
    if ([self.item getIsClick]) {
        self.backOutlet.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    }else{
        self.backOutlet.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backOutlet.layer.borderWidth = 1.0;
    
    self.backgroundColor = [UIColor clearColor];
    self.actionOutlet.textColor = [UIColor whiteColor];
    
    // for BadgeView
    self.badge = [[JSBadgeView alloc] initWithParentView:self.badgeContainerView alignment:JSBadgeViewAlignmentCenter];
    self.badge.badgeBackgroundColor=[UIColor colorWithRed:36.0/255.0 green:105.0/255.0 blue:167.0/255.0 alpha:1.0];
    self.badge.badgeTextShadowColor=[UIColor clearColor];
    
}

- (void)setBadgeString:(NSString *)badgeString{
    
    if ([badgeString intValue]>0) {
        self.badge.badgeText = badgeString;
        self.badgeContainerView.hidden=NO;
    }else{
        self.badgeContainerView.hidden=YES;
    }
}

-(void)clickNotify{
    [self.item setIsClick:false];
    self.backOutlet.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
}

-(void)setImage:(UIImage *)image{
    self.imageOutlet.image = image;
}

-(void)setAction:(NSString *)string{
    self.actionOutlet.text = string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.item setIsClick:true];
        self.backOutlet.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    }
    // Configure the view for the selected state
}

@end
