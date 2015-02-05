//
//  jobListTableViewCell.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "jobListTableViewCell.h"

@implementation jobListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectedFlag=CELLUNSELECTED;
    self.checkIconView.image=[UIImage imageNamed:@"check_out"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
}

@end
