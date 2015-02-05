//
//  PersonProfileViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "profileImageView.h"

#import "ProfileView1.h"
#import "ProfileView2.h"
@interface PersonProfileViewController ()
{
    NSArray *_userImageArray;
}

@property (strong,nonatomic)ProfileView2 *expView;
@property (strong,nonatomic)ProfileView1 *titleView;
@property (strong,nonatomic)profileImageView *coverFlowImageView;
@end

@implementation PersonProfileViewController


-(void)prepareDataSourceBeforeLoad
{
    if (_userImageArray==nil) {
        _userImageArray=[NSArray array];
        for (int i = 0; i <20 ; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
           _userImageArray=[_userImageArray arrayByAddingObject:image];
        }
    }

};


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareDataSourceBeforeLoad];
    //初始化复用视图
    
    CGRect frame=CGRectMake(self.parentView.bounds.origin.x, self.parentView.bounds.origin.y,self.parentView.bounds.size.width, self.parentView.bounds.size.height);
    
    
    self.coverFlowImageView=[[profileImageView alloc]initWithFrame:frame];
    self.coverFlowImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;

    if (_userImageArray!=nil) {
        [self.coverFlowImageView initCoverFlowWithDataSource:_userImageArray];
    }else
    {
        self.coverFlowImageView.ImageCoverFlowView.backgroundColor=[UIColor blackColor];
    }
    [self.parentView addSubview:self.coverFlowImageView];
    
    
    
    
    ProfileView2 *expView=[[ProfileView2 alloc]initWithFrame:CGRectMake(self.profileExpView.bounds.origin.x, self.profileExpView.bounds.origin.y, self.profileExpView.bounds.size.width, self.profileExpView.bounds.size.height)];
    expView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.profileExpView addSubview:expView];
    
    
    
    ProfileView1 *briefView=[[ProfileView1 alloc]initWithFrame:CGRectMake(self.profileBriefView.bounds.origin.x, self.profileBriefView.bounds.origin.y, self.profileBriefView.bounds.size.width, self.profileBriefView.bounds.size.height)];
    briefView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.profileBriefView addSubview:briefView];
    
}

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

- (IBAction)sendInvitationBtnAction:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择职位"  otherButtonTitles:@"创建新职位", nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        
    }else if (buttonIndex == 1) {
        
        
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

@end
