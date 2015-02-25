//
//  CustomCollectionViewCell.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CustomCollectionViewCell: UICollectionViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *ContentImage;
@property (weak, nonatomic) IBOutlet UIImageView *markIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabelWithoutUnit;
@end
