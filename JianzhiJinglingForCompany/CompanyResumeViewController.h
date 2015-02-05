//
//  CompanyResumeViewController.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "MCPagerView.h"
@interface CompanyResumeViewController : UIViewController<UIScrollViewDelegate,QRadioButtonDelegate,MCPagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>


-(UIImage *)compressImage:(UIImage *)imgSrc size:(int)width;

@property (nonatomic)NSInteger pages;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollviewOutlet;
@end
