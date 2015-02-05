//
//  loginTableViewCell.m
//  jobSearch
//
//  Created by 田原 on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "loginTableViewCell.h"

@implementation loginTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (IBAction)registerAction:(UIButton *)sender {
    [self.item setTapFlag:ACTION_REGISTERFLAG];
    self.item.action(self.menu,self.item);
}

- (IBAction)loginAction:(UIButton *)sender {
    [self.item setTapFlag:ACTION_LOGINFLAG];
    self.item.action(self.menu,self.item);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
