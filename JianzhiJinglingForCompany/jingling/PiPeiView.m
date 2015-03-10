//
//  PiPeiView.m
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "PiPeiView.h"
#import "PopoverView.h"
#import "freeselectViewCell.h"
#import "AsyncImageView.h"
#import "DateUtil.h"
#import "NSDate+Category.h"
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"
#import "netAPI.h"
#import "jobPublicationViewController.h"
#import "jobListViewController.h"
#import "previewVedioVC.h"
#import "LoginManager.h"
static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface PiPeiView ()<PopoverViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>

{
    MBProgressHUD *hub;
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
}
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;

@property (weak, nonatomic) IBOutlet AsyncImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
//@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
//@property (weak, nonatomic) IBOutlet UILabel *jobSettlementWay;
@property (weak, nonatomic) IBOutlet UITextView *jobDescribleLabel;

//@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;

@property (strong, nonatomic) IBOutlet UIView *view1;

@end

@implementation PiPeiView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobDescribleLabel.editable=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
}

- (IBAction)showWorkTime:(id)sender {
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-40, 160)];
    [PopoverView showPopoverAtPoint:CGPointMake(88, 135) inView:self.view withTitle:@"工作时间" withContentView:self.view1 delegate:self];
}

- (IBAction)delete:(id)sender {
    [self.childViewDelegate deleteJob:self.index];
}

- (IBAction)apply:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:Text_CancelBtnText destructiveButtonTitle:Text_JobSelection  otherButtonTitles:Text_CreateNewJob, nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        jobListViewController *joblistForChoice=[[jobListViewController alloc]init];
        joblistForChoice.user_id=[self.userModel getjob_user_id];
        [self.navigationController pushViewController:joblistForChoice animated:YES];
        [actionSheet dismissWithClickedButtonIndex:nil animated:YES];
        
    }else if (buttonIndex == 1) {
        if ([LoginManager isOrNotLogin]==NO) {
            ALERT(@"请先登录");
            return;
        }
        if ([LoginManager isOrNotSettingComProfile]==NO) {
            ALERT(@"请先到“企业详请“编辑企业信息，再发布职位!");
            return;
        }
        jobPublicationViewController *newJobVC=[[jobPublicationViewController alloc]init];
        
        [self.navigationController pushViewController:newJobVC animated:YES];
        [actionSheet dismissWithClickedButtonIndex:nil animated:YES];
        
    }else if(buttonIndex == 2) {
        
        
    }else if(buttonIndex == 3) {
        
        
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{

}


- (void)timeViewInit{
    
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 120)/7;
    
    selectfreetimetitleArray = @[[UIImage imageNamed:@"resume_7"],
                                 [UIImage imageNamed:@"resume_1"],
                                 [UIImage imageNamed:@"resume_2"],
                                 [UIImage imageNamed:@"resume_3"],
                                 [UIImage imageNamed:@"resume_4"],
                                 [UIImage imageNamed:@"resume_5"],
                                 [UIImage imageNamed:@"resume_6"],
                                 
                                 ];
    
    selectfreetimepicArray = @[[UIImage imageNamed:@"resume_am1"],
                               [UIImage imageNamed:@"resume_am2"],
                               [UIImage imageNamed:@"resume_pm1"],
                               [UIImage imageNamed:@"resume_pm2"],
                               [UIImage imageNamed:@"resume_night1"],
                               [UIImage imageNamed:@"resume_night2"]
                               ];
    
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
    
    if ([[self.userModel getuserFreeTime] count]>0) {
        
        for (NSNumber *t in [self.userModel getuserFreeTime]) {
            if ([t intValue]>0) {
                int n=[t intValue];
                if (n<21&&n>=0) {
                    selectFreeData[n]=TRUE;
                }
                
            }
        }
        
    }
    
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    
}

- (IBAction)showPersonalVedio:(id)sender {
    
    
    
    if ([[self.userModel getuserVideoURL]length]<4 ) {
        ALERT(Text_NoVideo);
        return;
    }
    previewVedioVC *vc = [[previewVedioVC alloc]init];
    vc.vedioPath = [self.userModel getuserVideoURL];
    vc.type = [NSNumber numberWithInt:preview];
    vc.title = @"我的视频介绍";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initData{
    if(_userModel)
    {
        //设置头像
        NSString *imageUrl;
        NSArray *imageUrlArray=[self.userModel getImageFileURL];
        
        if ([imageUrlArray count]>0) {
            NSString *url1=[imageUrlArray objectAtIndex:0];
            
            if ([url1 length]>4) {
                if ([[url1 substringToIndex:4] isEqualToString:@"http"])
                    imageUrl=url1;
            }
            if ([imageUrl length]>4) {
                self.entepriseLogoView.contentMode = UIViewContentModeScaleAspectFill;
                self.entepriseLogoView.clipsToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.entepriseLogoView];
                self.entepriseLogoView.imageURL=[NSURL URLWithString:imageUrl];
            }else{
                self.entepriseLogoView.image=[UIImage imageNamed:@"placeholder"];
            }
        }
        //设置姓名
        self.jobTitleLabel.text=[NSString stringWithFormat:@"%@",[self.userModel getuserName]];
        //设置性别
        if ([[self.userModel getuserGender]intValue]==0) {
            self.genderLogoImage.image=[UIImage imageNamed:@"resume_male"];
        }else
        {
            self.genderLogoImage.image=[UIImage imageNamed:@"resume_female"];
        }
        
        //设置年龄
        self.personAgeLabel.text=[NSString stringWithFormat:@"%ld",(long)[DateUtil ageWithDateOfBirth:[self.userModel getuserBirthday]]];
        
        //设置电话
        self.jobAddressLabel.text=[NSString stringWithFormat:@"%@",[self.userModel getuserSchool]];
        
        //设置距离
        geoModel *usergeo=[self.userModel getuserLocationGeo];
        
        self.jobDistanceLabel.text=[NSString stringWithFormat:@"%.2f",[userModel getDistance:@[[NSNumber numberWithDouble:[usergeo getLat]],[NSNumber numberWithDouble:[usergeo getLon]]]]];
        
        //设置时间戳
        self.jobPublishTimeLabel.text=[[self.userModel getUpdateAt]timeIntervalDescription];
        
        
        //设置求职意向
        //        self.jobSalaryLabel.text=[NSString stringWithFormat:@"%@",[self.userModel getuserHopeJobType]];
        
        self.jobWorkPeriodLabel.hidden=YES;
        
        
        self.personalBriefIntro.text=[NSString stringWithFormat:@"%@",[self.userModel getuserExperience]];
        //
        self.jobDescribleLabel.text=[NSString stringWithFormat:@"%@",[self.userModel getuserIntroduction]];
    }
}

#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(freecellwidth, freecellwidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    [collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    freeselectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectFreecellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[freeselectViewCell alloc]init];
    }
    //[[cell imageView]setFrame:CGRectMake(0, 0, freecellwidth, freecellwidth)];
    if (indexPath.row>=0 && indexPath.row<7) {
        cell.imageView.image = [selectfreetimetitleArray objectAtIndex:indexPath.row];
    }
    
    
    if (indexPath.row>=7 && indexPath.row<14) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:1];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:0];
        }
        
    }
    if (indexPath.row>=14 && indexPath.row<21) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:3];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:2];
        }
    }
    if (indexPath.row>=21 && indexPath.row<28) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:5];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:4];
        }
    }
    return cell;
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
