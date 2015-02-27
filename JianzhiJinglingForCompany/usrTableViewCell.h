//
//  usrTableViewCell.h
//  jobSearch
//
//  Created by 田原 on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface usrTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *usrAvatarOutlet;
@property (weak, nonatomic) IBOutlet UILabel *usrNameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *usrActionOutlet;

-(void)setUsrAvatar:(UIImage *)image;
-(void)setusrAction:(NSString *)string;
-(void)setusrName:(NSString *)name;
-(void)setUsrAvatarWithURL:(NSString*)url;
@end
