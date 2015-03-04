//
//  MLIntroduceVC.h
//  jobSearch
//
//  Created by RAY on 15/2/28.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVNMaskedPageControl.h"

@interface MLIntroduceVC : UIViewController<UIScrollViewDelegate,KVNMaskedPageControlDataSource>
@property (weak, nonatomic) KVNMaskedPageControl *pageControl;
@property (nonatomic)NSInteger pages;

@end
