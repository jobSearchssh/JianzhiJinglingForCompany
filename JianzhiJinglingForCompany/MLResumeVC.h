//
//  MLResumeVC.h
//  jobSearch
//
//  Created by 田原 on 15/1/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "MCPagerView.h"
#import "freeselectViewCell.h"

@interface MLResumeVC : UIViewController<UIScrollViewDelegate,QRadioButtonDelegate,MCPagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

-(UIImage *)compressImage:(UIImage *)imgSrc size:(int)width;

@property (nonatomic)NSInteger pages;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollviewOutlet;

@end
