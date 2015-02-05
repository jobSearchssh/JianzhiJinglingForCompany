//
//  profileImageView.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/26/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface profileImageView : UIView
@property (strong, nonatomic) IBOutlet UIView *ImageCoverFlowView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userEducationLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;

-(void)initCoverFlowWithDataSource:(NSArray*)userImageArray;
@end
