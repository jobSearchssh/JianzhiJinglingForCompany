//
//  PiPeiView.h
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"
@interface PiPeiView : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITextView *personalBriefIntro;

@property (weak, nonatomic) IBOutlet UILabel *personAgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderLogoImage;

@property (strong,nonatomic)userModel *userModel;

- (IBAction)showPersonalVedio:(id)sender;
- (void)initData;
@end
