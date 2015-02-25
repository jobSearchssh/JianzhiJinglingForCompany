//
//  sideNormalTableViewCell.h
//  jobSearch
//
//  Created by 田原 on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuartzCore/QuartzCore.h"
#import "RESideMenuItem.h"
#import "JSBadgeView.h"


@interface sideNormalTableViewCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *backOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imageOutlet;
@property (weak, nonatomic) IBOutlet UILabel *actionOutlet;
@property (weak, nonatomic) RESideMenuItem *item;

@property (weak, nonatomic) IBOutlet UIView *badgeContainerView;

@property (strong, nonatomic)JSBadgeView *badge;

@property (strong, nonatomic)NSString *badgeString;

-(void)setImage:(UIImage *)image;
-(void)setAction:(NSString *)string;
-(void)notifyDatasetChange;
-(void)setBadgeViewHiden:(BOOL)hiden;
- (void)setBadgeString:(NSString *)_badgeString;

@end
