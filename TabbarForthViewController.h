//
//  TabbarForthViewController.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarForthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *myMatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPublishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *myfocusLabel;
- (IBAction)searchBtnAction:(id)sender;
- (IBAction)myfocusBtnAction:(id)sender;
- (IBAction)myPublishedBtnAction:(id)sender;
- (IBAction)myMatchBtnAction:(id)sender;
- (IBAction)sendFeedBackAction:(id)sender;
- (IBAction)statmentBtnAction:(id)sender;
- (IBAction)logoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)changeSelfProfile:(id)sender;

-(void)setMyfocusLabelBadge:(NSString*) badge;
-(void)setMyPublishedLabelBadge:(NSString*) badge;
-(void)setMyMatchLabelBadge:(NSString*) badge;

@end
