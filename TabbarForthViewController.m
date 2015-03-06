//
//  TabbarForthViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "TabbarForthViewController.h"
#import "JSBadgeView.h"
#import "PersonListViewController.h"
#import "MLMatchVC.h"
#import "CompanyResumeViewController.h"
#import "ComProfileViewController.h"

#import "QuartzCore/QuartzCore.h"
#import "CustomButton1.h"
#import "MLLoginVC.h"
#import "JobPublishedListViewController.h"
@interface TabbarForthViewController ()




@property (weak, nonatomic) IBOutlet UIButton *myFocusBtn;

- (IBAction)touchDown:(id)sender;

- (IBAction)BtnTouchCancel:(id)sender;

@end

@implementation TabbarForthViewController



-(void)ButtonStyleChange
{
    [self.myFocusBtn setTag:2];
    CALayer * downButtonLayer = [self.myFocusBtn layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:10.0];
    [downButtonLayer setBorderWidth:3.0];
    [downButtonLayer setBackgroundColor:[[UIColor yellowColor]CGColor]];
    [downButtonLayer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.view insertSubview:self.myFocusBtn atIndex:self.myFocusBtn.tag];
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view from its nib.//设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    

    self.title=@"更多";
    
    
    [self.mainScrollView setContentSize:CGSizeMake(MainScreenWidth, self.logoutBtn.frame.origin.y+self.logoutBtn.frame.size.height+20)];
    
    
    //设置badge
    [self setMyfocusLabelBadge:@"1"];
    
}



-(void)setMyfocusLabelBadge:(NSString*) badge
{
    JSBadgeView *badgeView=[[JSBadgeView alloc]initWithParentView:self.myfocusLabel alignment:JSBadgeViewAlignmentCenterRight];
//    badgeView.badgeBackgroundColor=[UIColor blueColor];
    if (badge==nil) {
        badgeView.badgeText=nil;
        return;
    }
    badgeView.badgeText=badge;
    
}
-(void)setMyPublishedLabelBadge:(NSString*) badge
{
    JSBadgeView *badgeView=[[JSBadgeView alloc]initWithParentView:self.myfocusLabel alignment:JSBadgeViewAlignmentCenterRight];
    //    badgeView.badgeBackgroundColor=[UIColor blueColor];
    if (badge==nil) {
        badgeView.badgeText=nil;
        return;
    }
    badgeView.badgeText=badge;
    

}
-(void)setMyMatchLabelBadge:(NSString*) badge
{
    
    JSBadgeView *badgeView=[[JSBadgeView alloc]initWithParentView:self.myfocusLabel alignment:JSBadgeViewAlignmentCenterRight];
    //    badgeView.badgeBackgroundColor=[UIColor blueColor];
    if (badge==nil) {
        badgeView.badgeText=nil;
        return;
    }
    badgeView.badgeText=badge;
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

- (IBAction)searchBtnAction:(id)sender {
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
    NSLog(@"touch SearchBtn");
    
    
}

- (IBAction)myfocusBtnAction:(id)sender {
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
    
    PersonListViewController *personListVC=[[PersonListViewController alloc]init];
    personListVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:personListVC animated:YES];
    
       NSLog(@"touch myfocusBtn");
    
    
}

- (IBAction)myPublishedBtnAction:(id)sender {
   
    JobPublishedListViewController *publishedJobListVC=[[JobPublishedListViewController alloc]init];
    
    publishedJobListVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:publishedJobListVC animated:YES];
       NSLog(@"touch myPublishedBtn");
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
}

- (IBAction)myMatchBtnAction:(id)sender {
    
    
    MLMatchVC *forthVC=[[MLMatchVC alloc]init];
    forthVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:forthVC animated:YES];
       NSLog(@"touch myMatchBtn");
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
}

- (IBAction)sendFeedBackAction:(id)sender {
       NSLog(@"touch sendFeedBack");
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
}

- (IBAction)statmentBtnAction:(id)sender {
       NSLog(@"touch statmentBtn");
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
}

- (IBAction)logoutAction:(id)sender {
       NSLog(@"touch logout");
    MLLoginVC *loginVC=[[MLLoginVC alloc]init];
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
//    UIButton *btn=sender;
//    [self clearOtherBtnChoiceStyle:btn exceptedTag:btn.tag];
}


- (IBAction)changeSelfProfile:(id)sender {
    
    

    ComProfileViewController *companyProfileVC=[[ComProfileViewController alloc]init];
    
    companyProfileVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyProfileVC animated:YES];
    
}
//touchDrag Enter

-(void)clearOtherBtnChoiceStyleExceptedTag:(NSInteger) tag
{
    for (int i=800; i<807; i++) {
        if (i!=tag)
        {
            CustomButton1 *btn=(CustomButton1*)[self.view viewWithTag:i];
            NSLog(@"i=%d",i);
            NSLog(@"btn will changed:%d",btn.tag);
            [btn buttonColorUnClick];
        }
    }


}


- (IBAction)touchDown:(id)sender {
    
    CustomButton1 *btn=sender;
    [self clearOtherBtnChoiceStyleExceptedTag:btn.tag];
    
    //有效
    
  
    [btn buttonColorWhenClicked];
}



- (IBAction)BtnTouchCancel:(id)sender {
    CustomButton1 *btn=sender;
    [btn buttonColorUnClick];
    
}
@end
