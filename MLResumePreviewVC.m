//
//  MLResumePreviewVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumePreviewVC.h"
#import "MLResumeVC.h"
#import "jobListViewController.h"
#import "jobPublicationViewController.h"
#import "netAPI.h"
#import "BadgeManager.h"
#import "UIViewController+HUD.h"
#import "RESideMenu.h"
#import "AsyncImageView.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "UIViewController+LoginManager.h"
static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface MLResumePreviewVC (){
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
}



@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollviewOutlet;
//第一项
@property (weak, nonatomic) IBOutlet UIView *coverflowOutlet;
//第二项
@property (strong, nonatomic) IBOutlet UIView *usrinfo1Outlet;
//第三项
@property (strong, nonatomic) IBOutlet UIView *usrinfo2Outlet;
@property (weak, nonatomic) IBOutlet AsyncImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usrNameOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *sexOutlet;
@property (weak, nonatomic) IBOutlet UILabel *ageOutlet;
@property (weak, nonatomic) IBOutlet UILabel *locationOutlet;
@property (weak, nonatomic) IBOutlet UILabel *intentionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *phoneOutlet;

//第四项
@property (strong, nonatomic) IBOutlet UIView *collectionViewOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
//第五项
@property (strong, nonatomic) IBOutlet UIView *usrinfo3Outet;
@property (weak, nonatomic) IBOutlet UILabel *workexperienceOutlet;
@property (weak, nonatomic) IBOutlet UILabel *userIntroductionOutlet;

//最后一项
@property (strong, nonatomic) IBOutlet UIView *userInfoBtnView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *RefuseAndAcceptLabel;

//接受  拒绝 处理
@property (strong, nonatomic) IBOutlet UIView *userInfor7View;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendMessage;
- (IBAction)refuseAction:(id)sender;

- (IBAction)acceptAction:(id)sender;

//右侧按钮
@property (strong,nonatomic)UIBarButtonItem *rightBarBtn;
- (IBAction)invitationAction:(id)sender;

- (IBAction)showVedioAction:(id)sender;

@end

@implementation MLResumePreviewVC


-(UIBarButtonItem*)rightBarBtn
{
    if (_rightBarBtn==nil) {
        _rightBarBtn=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(addToFavorite)];
        
    }
    return _rightBarBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
    }
    self.mainScrollviewOutlet.delegate=self;
    [self.navigationItem setTitle:@"简历预览"];
    
    if (!self.hideRightBarButton) {
        self.navigationItem.rightBarButtonItem=self.rightBarBtn;
        [self.navigationItem.rightBarButtonItem setTitle:@"收藏"];
    }
    
    [self.coverflowOutlet setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width*0.6)];
    [self.mainScrollviewOutlet addSubview:self.coverflowOutlet];
    
    if (self.hideAcceptBtn) {
        self.acceptBtn.hidden=YES;
        self.refuseBtn.hidden=YES;
        for (UILabel *label in self.RefuseAndAcceptLabel) {
            label.hidden=YES;
        }
    }
    if (self.thisUser!=nil) {
        [self initfromUpperVC:self.thisUser];
    }
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)initfromUpperVC:(userModel *)userModel{
    
    
    //第一项
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    
    //设置头像
    NSMutableArray *sourceImagesURL = [userModel getImageFileURL];
    CGSize size = CGSizeMake(225, 225);
    UIImage *temp = [self scaleToSize:[UIImage imageNamed:@"placeholder"] size:size];
    
    for (NSUInteger i=0; i<[sourceImagesURL count]; i++) {
        [sourceImages addObject:temp];
    }
    //背景黑
    CGRect coverflowFrame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,self.coverflowOutlet.frame.size.height -20);
    //添加coverflow
    coverFlowView *cfView = [coverFlowView coverFlowViewWithFrame:coverflowFrame andImages:sourceImages andURLs:sourceImagesURL sideImageCount:2 sideImageScale:0.55 middleImageScale:0.7];
    [cfView setDuration:0.3];
    [self.coverflowOutlet addSubview:cfView];
    //第二项
    //    [self.usrinfo1Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,110)];
    //    [self.mainScrollviewOutlet addSubview:self.usrinfo1Outlet];
    //第三项
    NSString *imageUrl;
    NSArray *imageUrlArray=[userModel getImageFileURL];
    if ([imageUrlArray count]>0) {
        NSString *url1=[imageUrlArray firstObject];
        if ([url1 length]>4) {
            if ([[url1 substringToIndex:4] isEqualToString:@"http"])
                imageUrl=url1;
        }
        
        if ([imageUrl length]>4) {
           self.userImage.contentMode = UIViewContentModeScaleAspectFill;
            self.userImage.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.userImage];
            self.userImage.imageURL=[NSURL URLWithString:imageUrl];
        }else{
            self.userImage.image=[UIImage imageNamed:@"placeholder"];
        }
    }
    //用户名字
    NSString *usrname = [userModel getuserName];
    [self.usrNameOutlet setNumberOfLines:0];
    [self.usrNameOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize usrnameSize = [usrname sizeWithFont:[self.usrNameOutlet font] constrainedToSize:CGSizeMake(0,0) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.usrNameOutlet setFrame:CGRectMake(self.usrNameOutlet.frame.origin.x,
                                            self.usrNameOutlet.frame.origin.y,
                                            usrnameSize.width,
                                            usrnameSize.height)];
    [self.usrNameOutlet setText:usrname];
    
    [self.sexOutlet setFrame:CGRectMake(
                                        300,
                                        self.sexOutlet.frame.origin.y,
                                        self.sexOutlet.frame.size.width,
                                        self.sexOutlet.frame.size.height)];
    //性别
    if ([userModel getuserGender].intValue == 0) {
        self.sexOutlet.image = [UIImage imageNamed:@"resume_male"];
    }else if ([userModel getuserGender].intValue == 1){
        self.sexOutlet.image = [UIImage imageNamed:@"resume_female"];
    }else{
        self.sexOutlet.image = Nil;
    }
    
    //年龄
    if ([userModel getuserBirthday] != Nil) {
        @try {
            NSString *ageString = [NSString stringWithFormat:@"%ld岁",(long)[DateUtil ageWithDateOfBirth:[userModel getuserBirthday]]];
            self.ageOutlet.text = ageString;
        }
        @catch (NSException *exception) {
            self.ageOutlet.text = @"未知年龄";
        }
    }else{
        self.ageOutlet.text = @"未知年龄";
    }
    //电话
    self.phoneOutlet.text = [userModel getuserPhone];
    //位置
    NSString *usrLoaction = [NSString stringWithFormat:@"%@%@%@",[userModel getuserProvince],[userModel getuserCity],[userModel getuserDistrict]];
    [self.locationOutlet setNumberOfLines:0];
    [self.locationOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize locationOutletlabelsize = [usrLoaction sizeWithFont:[self.locationOutlet font] constrainedToSize:CGSizeMake(self.locationOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.locationOutlet setFrame:CGRectMake(self.locationOutlet.frame.origin.x,
                                             self.locationOutlet.frame.origin.y, locationOutletlabelsize.width, locationOutletlabelsize.height)];
    [self.locationOutlet setText:usrLoaction];
    
    const NSDictionary *TYPESELECTEDDICT=@{@"模特/礼仪":@"0", @"促销/导购":@"1", @"销售":@"2" ,@"传单派发":@"3" ,@"安保":@"4" ,@"钟点工":@"5", @"法律事务":@"6", @"服务员":@"7" ,@"婚庆":@"8", @"配送/快递":@"9", @"化妆":@"10", @"护工/保姆":@"11", @"演出":@"12", @"问卷调查":@"13", @"志愿者":@"14" ,@"网络营销":@"15" ,@"导游":@"16", @"游戏代练":@"17", @"家教":@"18", @"软件/网站开发":@"19", @"会计":@"20", @"平面设计/制作":@"21", @"翻译":@"22", @"装修":@"23", @"影视制作":@"24", @"搬家":@"25", @"其他":@"26"};
    
    //设置工作类型
    NSMutableDictionary *typeForReanlysis=[NSMutableDictionary dictionary];
    NSArray *keyword=[TYPESELECTEDDICT allKeys];
    for (NSString *value in keyword) {
        [typeForReanlysis setObject:value forKey:[TYPESELECTEDDICT objectForKey:value]];
    }
    NSString *usrintention=@"";
    for (int i=0; i<[[userModel getuserHopeJobType] count]; i++) {
        usrintention = [usrintention stringByAppendingString:[typeForReanlysis objectForKey: [NSString stringWithFormat:@"%@",[[userModel getuserHopeJobType]objectAtIndex:i]]]];
    }
    
    [self.intentionOutlet setNumberOfLines:0];
    [self.intentionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize intentionOutletlabelsize = [usrLoaction sizeWithFont:[self.intentionOutlet font] constrainedToSize:CGSizeMake(self.intentionOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.intentionOutlet setFrame:CGRectMake(self.intentionOutlet.frame.origin.x,
                                              self.intentionOutlet.frame.origin.y,
                                              intentionOutletlabelsize.width,
                                              intentionOutletlabelsize.height)];
    [self.intentionOutlet setText:usrintention];
    
    [self.usrinfo2Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.origin.y+self.coverflowOutlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,self.intentionOutlet.frame.origin.y+self.intentionOutlet.frame.size.height+20)];
    [self.mainScrollviewOutlet addSubview:self.usrinfo2Outlet];
    
    //第四项
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 110)/7;
    selectfreetimetitleArray = @[[UIImage imageNamed:@"resume_7"],
                                 [UIImage imageNamed:@"resume_1"],
                                 [UIImage imageNamed:@"resume_2"],
                                 [UIImage imageNamed:@"resume_3"],
                                 [UIImage imageNamed:@"resume_4"],
                                 [UIImage imageNamed:@"resume_5"],
                                 [UIImage imageNamed:@"resume_6"]
                                 ];
    selectfreetimepicArray = @[[UIImage imageNamed:@"resume_am1"],
                               [UIImage imageNamed:@"resume_am2"],
                               [UIImage imageNamed:@"resume_pm1"],
                               [UIImage imageNamed:@"resume_pm2"],
                               [UIImage imageNamed:@"resume_night1"],
                               [UIImage imageNamed:@"resume_night2"]
                               ];
    
    NSArray *freeTime = [userModel getuserFreeTime];
    for (int index = 0; index < 21; index++) {
        selectFreeData[index] = false;
    }
    for (NSNumber *free in freeTime) {
        if (free.intValue >=0 && free.intValue < 21) {
            selectFreeData[free.intValue] = true;
        }
    }
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    [self.collectionViewOutlet setFrame:CGRectMake(0,self.usrinfo2Outlet.frame.origin.y+self.usrinfo2Outlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,60+freecellwidth*4+50)];
    [self.mainScrollviewOutlet addSubview:self.collectionViewOutlet];
    [self.selectfreeCollectionOutlet reloadData];
    
    //第五项
    
    NSString *intro = [userModel getuserIntroduction];
    NSString  *testintroFormat = [intro stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ];
    [self.userIntroductionOutlet setNumberOfLines:0];
    [self.userIntroductionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testintrolabelsize = [testintroFormat sizeWithFont:[self.userIntroductionOutlet font] constrainedToSize:CGSizeMake(self.userIntroductionOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.userIntroductionOutlet setFrame:CGRectMake(self.userIntroductionOutlet.frame.origin.x,
                                                     self.userIntroductionOutlet.frame.origin.y, testintrolabelsize.width,
                                                     testintrolabelsize.height)];
    [self.userIntroductionOutlet setText:testintroFormat];
    
    
    NSString *workexperience = [userModel getuserExperience];
    NSString  *workexperienceFormat = [workexperience stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ];
    [self.workexperienceOutlet setNumberOfLines:0];
    [self.workexperienceOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize testworkexperiencelabelsize = [workexperienceFormat sizeWithFont:[self.workexperienceOutlet font] constrainedToSize:CGSizeMake(self.workexperienceOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.workexperienceOutlet setFrame:CGRectMake(self.workexperienceOutlet.frame.origin.x,
                                                   self.workexperienceOutlet.frame.origin.y, testworkexperiencelabelsize.width, testworkexperiencelabelsize.height)];
    [self.workexperienceOutlet setText:workexperienceFormat];
    
    [self.usrinfo3Outet setFrame:CGRectMake(0,
                                            self.collectionViewOutlet.frame.origin.y+self.collectionViewOutlet.frame.size.height,
                                            [UIScreen mainScreen].bounds.size.width,
                                            testintrolabelsize.height + testworkexperiencelabelsize.height+150)];
    NSLog(@"%f  %f",testintrolabelsize.height,testworkexperiencelabelsize.height);
    [self.mainScrollviewOutlet addSubview:self.usrinfo3Outet];
    
    if (self.stateFlag==UnhanldedState) {
        self.userInfor7View.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.userInfor7View setFrame:CGRectMake(0,self.usrinfo3Outet.frame.origin.y+self.usrinfo3Outet.frame.size.height,MainScreenWidth,self.inviteBtn.bounds.size.height)];
        [self.mainScrollviewOutlet addSubview:self.userInfor7View];
        //设置最终长度
        [self.mainScrollviewOutlet setContentSize:CGSizeMake(0,self.userInfor7View.frame.origin.y+self.userInfor7View.frame.size.height+10)];
    }
    else if(self.stateFlag==InviteState){
        [self.userInfoBtnView setFrame:CGRectMake(0,self.usrinfo3Outet.frame.origin.y+self.usrinfo3Outet.frame.size.height,MainScreenWidth,self.inviteBtn.bounds.size.height)];
        [self.mainScrollviewOutlet addSubview:self.userInfoBtnView];
        //设置最终长度
        [self.mainScrollviewOutlet setContentSize:CGSizeMake(0,self.userInfoBtnView.frame.origin.y+self.userInfoBtnView.frame.size.height)];
    }
    else if(self.stateFlag==hanldedState)
    {
        
    }
}

- (void)viewWillLayoutSubviews{
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.userInfor7View setFrame:CGRectMake(0,self.usrinfo3Outet.frame.origin.y+self.usrinfo3Outet.frame.size.height,MainScreenWidth,self.inviteBtn.bounds.size.height)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

#pragma --mark  添加收藏
- (void)addToFavorite{
   
    NSUserDefaults *myseting=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[myseting objectForKey:CURRENTUSERID];
    if (self.jobUserId==nil ||com_id==nil ) {
        ALERT(@"未登录或未找到该求职者，请重试");
    }
    else {
    [self showHudInView:self.mainScrollviewOutlet hint:@"收藏中.."];
    [netAPI starJobUser:com_id jobUserID:self.jobUserId withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if([[oprationModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]){
            
            ALERT(@"收藏成功，可前往“关注的人”查看");
            self.navigationItem.rightBarButtonItem.title=@"已收藏";
            self.rightBarBtn.enabled=NO;
#warning 带完成收藏成功后的逻辑
//            RESideMenu *sideMenu=[RESideMenu sharedInstance];
//            //获取原来的数
////            [sideMenu setBadgeView:2 badgeText:@"1"];
        }else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
            ALERT(error);
        }
    }];
    }
}

-(UIImage *)compressImage:(UIImage *)imgSrc size:(int)width
{
    CGSize size = {width, width};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

//coolection
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return NO;
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


- (IBAction)invitationAction:(id)sender {
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
    }
    else{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择职位"  otherButtonTitles:@"创建新职位", nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    }
}

- (IBAction)showVedioAction:(id)sender {
    ALERT(@"该用户没有视频");
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        jobListViewController *joblistForChoice=[[jobListViewController alloc]init];
        joblistForChoice.user_id=[self.thisUser getjob_user_id];
        [self.navigationController pushViewController:joblistForChoice animated:YES];
//        [actionSheet dismissWithClickedButtonIndex:nil animated:YES];
        
    }else if (buttonIndex == 1) {
        
        jobPublicationViewController *newJobVC=[[jobPublicationViewController alloc]init];
        [self.navigationController pushViewController:newJobVC animated:YES];
//        [actionSheet dismissWithClickedButtonIndex:nil animated:YES];
        
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
- (IBAction)refuseAction:(id)sender {
    
    if (self.thisUser==nil) {
        return;
    }
    [self showHudInView:self.mainScrollviewOutlet hint:@""];
    MLResumePreviewVC *__weak weakSelf=self;
    [netAPI refuseJobApply:[self.thisUser getApply_id] withBlock:^(oprationResultModel *oprationModel) {
        [weakSelf hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            ALERT(@"成功");
            self.refuseBtn.enabled=NO;
            self.acceptBtn.enabled=NO;
            //修改前页代码
          [[BadgeManager shareSingletonInstance]minusApplyCount];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"update" object:nil];
        }else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
            ALERT(error);
        }
    }];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}
- (IBAction)acceptAction:(id)sender {
    if (self.thisUser==nil) {
        return;
    }
    [self showHudInView:self.mainScrollviewOutlet hint:@""];
    MLResumePreviewVC *__weak weakSelf=self;
    [netAPI acceptJobApply:[self.thisUser getApply_id] withBlock:^(oprationResultModel *oprationModel) {
        [weakSelf hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            ALERT(@"成功");
            self.refuseBtn.enabled=NO;
            self.acceptBtn.enabled=NO;
            [[BadgeManager shareSingletonInstance]minusApplyCount];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"update" object:nil];
        }else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
            ALERT(error);
        }
    }];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}
@end
