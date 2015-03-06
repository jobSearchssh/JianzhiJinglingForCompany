//
//  jobPublicationViewController.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "freeselectViewCell.h"
#import "jobModel.h"
#define PublishNewJob 1
#define PublishedJob 2


@interface jobPublicationViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>

@property int viewStatus;
@property (strong,nonatomic)jobModel *publishedJob;
@property BOOL editButtonEnable;

@property BOOL isHideBottomBtn;
- (IBAction)TextField_DidEndOnExit:(id)sender;
@end
