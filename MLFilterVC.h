//
//  MLFilterVC.h
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishFilterDelegate <NSObject>
@required
- (void)finishFilter:(int)_distance Length:(int)length;

@end


@interface MLFilterVC : UIViewController

@property(nonatomic,weak) id<finishFilterDelegate> filterDelegate;

+ (MLFilterVC*)sharedInstance;

@end
