//
//  MLResumePreviewVC.h
//  jobSearch
//
//  Created by 田原 on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coverFlowView.h"
#import "freeselectViewCell.h"
#import "netAPI.h"
#import "MBProgressHUD.h"
#import "DateUtil.h"
#import "userModel.h"

#define UnhanldedState 1
#define hanldedState  2
#define InviteState 3

@protocol handleActionDelegate <NSObject>
-(void)deleteCellInUpperViewAtTableIndex:(NSIndexPath*)indexPath;
@end


@interface MLResumePreviewVC : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
@property NSInteger stateFlag;
@property(nonatomic,strong)NSString *jobUserId;
@property (nonatomic,strong)userModel *thisUser;
@property BOOL hideRightBarButton;

@property BOOL hideAcceptBtn;

@property BOOL isShowPhone;
@property (weak,nonatomic)id<handleActionDelegate> delegate;
@end
