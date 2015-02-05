//
//  CustomButton1.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CustomButton1.h"
#import "QuartzCore/QuartzCore.h"
#define BtnChooseBackgroundColor [[UIColor colorWithRed:0.69 green:0.73 blue:0.26 alpha:0.4]CGColor]

@implementation CustomButton1


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self setTag:2];
    [self buttonColorUnClick];
}


-(void)buttonColorUnClick
{   self.alpha=0.4f;
    CALayer * downButtonLayer = [self layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:10.0];
    [downButtonLayer setBorderWidth:2.0];
    [downButtonLayer setBackgroundColor:nil];
    [downButtonLayer setBorderColor:[[UIColor whiteColor] CGColor]];
   
}


-(void)buttonColorWhenClicked
{
//    [self setTag:3];
    self.alpha=1.0f;
    CALayer * downButtonLayer = [self layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:10.0];
    [downButtonLayer setBorderWidth:0.0];
    [downButtonLayer setBackgroundColor:BtnChooseBackgroundColor];
//    [downButtonLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
}


-(void)buttonColorWhenFinishedClick
{
//    [self setTag:4];
//    CALayer * downButtonLayer = [self layer];
//    [downButtonLayer setMasksToBounds:YES];
//    [downButtonLayer setCornerRadius:10.0];
//    [downButtonLayer setBorderWidth:3.0];
//    [downButtonLayer setBackgroundColor:[[UIColor redColor]CGColor]];
}


@end
