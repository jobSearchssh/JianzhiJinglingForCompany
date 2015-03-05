//
//  PiPeiView.h
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userModel.h"

@protocol childViewDelegate <NSObject>
@required
- (void)deleteJob:(int)index;
@end

@interface PiPeiView : UIViewController
{
    
}
@property (strong, nonatomic)id <childViewDelegate>childViewDelegate;
@property (weak, nonatomic) IBOutlet UITextView *personalBriefIntro;

@property (weak, nonatomic) IBOutlet UILabel *personAgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderLogoImage;

@property (strong,nonatomic)userModel *userModel;
@property (nonatomic) int index;

- (IBAction)showPersonalVedio:(id)sender;
- (void)initData;
@end
