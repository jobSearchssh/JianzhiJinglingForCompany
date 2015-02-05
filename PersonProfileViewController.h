//
//  PersonProfileViewController.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonProfileViewController : UIViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIView *profileBriefView;
@property (weak, nonatomic) IBOutlet UIView *profileExpView;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationBtn;
- (IBAction)sendInvitationBtnAction:(id)sender;

@end
