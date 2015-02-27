//
//  usrTableViewCell.m
//  jobSearch
//
//  Created by 田原 on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "usrTableViewCell.h"

@implementation usrTableViewCell
@synthesize usrAvatarOutlet;
@synthesize usrNameOutlet;
@synthesize usrActionOutlet;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] init];
}
-(void)setUsrAvatar:(UIImage *)image{
    self.usrAvatarOutlet.image = image;
}

-(void)setUsrAvatarWithURL:(NSString*)url{
    if ([url length]>4) {
        self.usrAvatarOutlet.contentMode = UIViewContentModeScaleAspectFill;
        self.usrAvatarOutlet.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.usrAvatarOutlet];
        self.usrAvatarOutlet.imageURL=[NSURL URLWithString:url];
    }else{
        self.usrAvatarOutlet.image=[UIImage imageNamed:@"tourists"];
    }
}


-(void)setusrAction:(NSString *)string{
    self.usrActionOutlet.text = string;
}
-(void)setusrName:(NSString *)name{
    self.usrNameOutlet.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
