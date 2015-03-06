//
//  jobPublicationViewController.m
//  JianzhiJinglingForCompany
//
//  Created by 郭玉宝 on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//
//引入自定义键盘管理
#import "IQKeyboardManager.h"
#import <BmobSDK/Bmob.h>
#import "jobPublicationViewController.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"
#import "JobPublishedListViewController.h"
#import "ZHPickView.h"
#import "QRadioButton.h"
#import "UIViewController+HUD.h"
#import "netAPI.h"
#import "createJobModel.h"
#import "RegexTest.h"

#import "netAPI.h"
#import "NSDate+Category.h"

#import "AJLocationManager.h"

#import "HZAreaPickerView.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

#import "AsyncImageView.h"
#import "imageButton.h"
#import "UIImage+RTTint.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>


#import "FileNameGenerator.h"
#define BeginDatePickViewTag 20001
#define EndDatePickViewTag 20002
#define TypePickViewTag 70001
#define EduTitlePickViewTag 70002
#define PaymentPickViewTag 70003

#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 10


#define WorkTimeOrigin False
#define WorkTimeChanged True
static NSString *selectFreecellIdentifier = @"freeselectViewCell";
@interface jobPublicationViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate,UIActionSheetDelegate,UIAlertViewDelegate,DropDownChooseDataSource,DropDownChooseDelegate,ZHPickViewDelegate,QRadioButtonDelegate,UITextFieldDelegate,AMapSearchDelegate,HZAreaPickerDelegate>
{
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
    
    NSArray *collectionViewDataArray;
    BOOL workTimeFlag;
    BOOL imageAddFlag;
    BOOL workPlaceFlag;
    geoModel *nowGeo;
    //DropDownList dataSourceArray
    NSArray *chooseArray;
    
    //pickViewDatasource
    NSDictionary *eduDict;
    NSDictionary *typeSelectedDict;
    NSDictionary *paymentSelectedDict;
    
    QRadioButton *_radio_male;
    QRadioButton *_radio_female;
    QRadioButton *_radio_noDemand;
    
    NSMutableArray *addedPicArray;
    NSString *fileTempPath;
    
    //复制变量
    NSDate *BeginTime;
    NSDate *endTime;
    NSString *province;
    NSString *city;
    NSString *district;
    NSString *detailAddress;
    //用于检验的变量
    NSString *titleString;
    NSString *TypeString;
    NSString *workPlaceString;
    NSString *paywayString;
    NSString *IntroSting;
    int gender;
    NSString *eduString;
    
    
}
@property (strong,nonatomic)AMapSearchAPI *search;
@property(strong,nonatomic)createJobModel *thisJob;

@property (strong,nonatomic)ZHPickView *datePicker;

@property(strong,nonatomic)DropDownListView *dropDownList1;


@property (strong, nonatomic) IBOutlet UIView *jobInfo1View;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *jobInfo2View;
@property (strong, nonatomic) IBOutlet UIView *jobInfo3View;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedCollectionView;
@property (strong, nonatomic) IBOutlet UIView *jobInfo4View;
@property (strong, nonatomic) IBOutlet UIView *publishBtnView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
- (IBAction)publishAction:(id)sender;



//简历填写控件
@property (weak, nonatomic) IBOutlet UITextField *jobTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *wantedNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *jobDescriptTextField;

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightMaxTextField;

@property (weak, nonatomic) IBOutlet UILabel *eduTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactPhone;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;


- (IBAction)showBeginTimeAction:(id)sender;

- (IBAction)showEndTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *beginTimeBtn;
- (IBAction)selectedPaymentAction:(id)sender;
- (IBAction)selectedEduAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


@property (weak, nonatomic) IBOutlet UIButton *jobPlaceLabel;
- (IBAction)selectDistrictAction:(id)sender;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

- (IBAction)findLocationBtnAction:(id)sender;

- (IBAction)selectedTypeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *ageMaxTextField;



//添加照片scrolView


@property (weak, nonatomic) IBOutlet UIScrollView *picScrollView;


//添加照片按钮
@property (strong, nonatomic) IBOutlet UIView *jobInfo6View;
- (IBAction)AddImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet AsyncImageView *logoImageView;

//再次发布
- (IBAction)publisedAgainAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *publishedAgainBtn;

@end
@implementation jobPublicationViewController



-(AMapSearchAPI*)search
{
    if (_search==nil) {
        //初始化检索对象
        [MAMapServices sharedServices].apiKey=@"7940ad72b6cad048cd56b9eef4495d81";
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"7940ad72b6cad048cd56b9eef4495d81" Delegate:self];
        _search.delegate=self;
    }
    return _search;
}

-(createJobModel*)thisJob
{
    if (_thisJob==nil) {
        _thisJob=[[createJobModel alloc]init];
        //设置默认值
        [_thisJob setjobGenderReq:2];
    }
    return _thisJob;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    workPlaceFlag=FALSE;
    self.mainScrollView.delegate=self;
    [self.navigationItem setTitle:@"发布职位"];
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    [sourceImages addObject:[UIImage imageNamed:@"0.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"1.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"2.jpg"]];
    
    typeSelectedDict=@{@"模特/礼仪":@"0", @"促销/导购":@"1", @"销售":@"2" ,@"传单派发":@"3" ,@"安保":@"4" ,@"钟点工":@"5", @"法律事务":@"6", @"服务员":@"7" ,@"婚庆":@"8", @"配送/快递":@"9", @"化妆":@"10", @"护工/保姆":@"11", @"演出":@"12", @"问卷调查":@"13", @"志愿者":@"14" ,@"网络营销":@"15" ,@"导游":@"16", @"游戏代练":@"17", @"家教":@"18", @"软件/网站开发":@"19", @"会计":@"20", @"平面设计/制作":@"21", @"翻译":@"22", @"装修":@"23", @"影视制作":@"24", @"搬家":@"25", @"其他":@"26"};
    
    eduDict=@{@"不限":@"1",@"初中及以下":@"2",@"高中":@"3",@"大专":@"4",@"本科":@"5",@"硕士":@"6",@"博士及以上":@"7"};
    
    paymentSelectedDict=@{@"日结":@"0",@"周结":@"1",@"月结":@"2",@"项目结":@"3"};
    
    
    //第一项
    
    self.jobInfo1View.autoresizesSubviews=YES;
    self.jobInfo1View.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.mainScrollView addSubview:self.jobInfo1View];
    
    //第二项
    [self.jobInfo2View setFrame:CGRectMake(0,120,MainScreenWidth,40)];
    [self.mainScrollView addSubview:self.jobInfo2View];
    
    //第三项  collectionView
    workTimeFlag=FALSE;
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = (MainScreenWidth - 110)/7;
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
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
    self.selectedCollectionView.delegate=self;
    self.selectedCollectionView.dataSource=self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectedCollectionView registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    
    [self.jobInfo3View setFrame:CGRectMake(0,self.jobInfo2View.frame.origin.y+self.jobInfo2View.frame.size.height,[UIScreen mainScreen].bounds.size.width,60+freecellwidth*4)];
    
    [self.mainScrollView addSubview:self.jobInfo3View];
    
    //dropDownListView
    //    [self dropDownInit];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editJob)];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    self.navigationItem.rightBarButtonItem.enabled=self.editButtonEnable;
    
    //第四项
    [self.jobInfo4View setFrame:CGRectMake(0,self.jobInfo3View.frame.origin.y+self.jobInfo3View.frame.size.height,[UIScreen mainScreen].bounds.size.width,660)];
    //    self.dropDownList1= [[DropDownListView alloc] initWithFrame:CGRectMake(0,0,MainScreenWidth, 40) dataSource:self delegate:self];
    //    self.dropDownList1.backgroundColor=[UIColor lightGrayColor];
    //    self.dropDownList1.mSuperView = self.jobInfo4View;
    //    [self.jobInfo4View addSubview:self.dropDownList1];
    
    
    [self.mainScrollView addSubview:self.jobInfo4View];
    
    
    //添加照片ScrollView
    addedPicArray =[[NSMutableArray alloc]init];
    
    //添加照片项
    imageAddFlag=NO;
    [self.jobInfo6View setFrame:CGRectMake(0,self.jobInfo4View.frame.origin.y+self.jobInfo4View.frame.size.height,[UIScreen mainScreen].bounds.size.width,150)];
    
    [self.mainScrollView addSubview:self.jobInfo6View];
    //设置最终长度
    [self.mainScrollView setContentSize:CGSizeMake(0,self.jobInfo6View.frame.origin.y+self.jobInfo6View.frame.size.height+150)];
    
    
    //添加PickView 响应时间
    _radio_male = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio_male.frame = CGRectMake(self.genderLabel.frame.origin.x+self.genderLabel.frame.size.width+10, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio_male setTitle:@"男" forState:UIControlStateNormal];
    [_radio_male setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio_male.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio_male];
    //    [_radio1 setChecked:YES];
    
    _radio_female = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio_female.frame = CGRectMake(_radio_male.frame.origin.x+_radio_male.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio_female setTitle:@"女" forState:UIControlStateNormal];
    [_radio_female setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio_female.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio_female];
    _radio_noDemand = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio_noDemand.frame = CGRectMake(_radio_female.frame.origin.x+_radio_female.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio_noDemand setTitle:@"不限" forState:UIControlStateNormal];
    [_radio_noDemand setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio_noDemand.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio_noDemand];
    if(PublishedJob==self.viewStatus)
    {
        //如果是查看已发布的页面走这里初始化
        self.navigationItem.title=@"历史发布";
        //        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editJob)];
        //        [self.navigationItem.rightBarButtonItem setTitle:@"修改"];
        
        [self publishedJobLoadData];
        [self cannotEditMode];
        [self initBtnViewWithBtnIndex:1];
        
    }else{
        [self initBtnViewWithBtnIndex:0];
    }
    
    //初始化GEO
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *geoString=[mySettingData objectForKey:CURRENTLOCATOIN];
    if (geoString!=nil) {
        CGPoint point=CGPointFromString(geoString);
        
        nowGeo=[[geoModel alloc]initWith:point.x lat:point.y];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isHideBottomBtn) {
        self.publishBtn.hidden=NO;
        self.publishBtn.enabled=NO;
        self.publishedAgainBtn.hidden=YES;
    }
}

-(void)initBtnViewWithBtnIndex:(NSInteger) flag
{
    //    //第五个buttonView
    //
    //    [self.publishBtnView setFrame:CGRectMake(0,self.jobInfo6View.frame.origin.y+50+self.jobInfo6View.frame.size.height,[UIScreen mainScreen].bounds.size.width,self.publishBtn.frame.size.height)];
    //
    //    [self.mainScrollView addSubview:self.publishBtnView];
    //
    //    //设置最终长度
    //    [self.mainScrollView setContentSize:CGSizeMake(0,self.publishBtnView.frame.origin.y+self.publishBtnView.frame.size.height)];
    if (flag==1) {
        self.publishBtn.hidden=YES;
        self.publishedAgainBtn.hidden=NO;
        self.publishedAgainBtn.enabled=NO;
        [self.publishedAgainBtn setTitle:@"先编辑，再发布" forState:UIControlStateNormal];
    }else
    {
        self.publishBtn.hidden=NO;
        self.publishedAgainBtn.hidden=YES;
    }
    
}

- (void)viewWillLayoutSubviews{
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    //layoutRadioButton
    _radio_male.frame = CGRectMake(self.genderLabel.frame.origin.x+self.genderLabel.frame.size.width+10, self.genderLabel.frame.origin.y-10, 50, 40);
    _radio_female.frame = CGRectMake(_radio_male.frame.origin.x+_radio_male.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
    _radio_noDemand.frame = CGRectMake(_radio_female.frame.origin.x+_radio_female.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
}

//加载网络请求，加载新提交的job
-(void)publishedJobLoadData
{
    [self showHudInView:self.view hint:@"正在加载中"];
    if (self.publishedJob==nil) {
        ALERT(@"错误");
        return;
    }
    [self updateViewWhenGetDataSuccessful:self.publishedJob];
}




-(void)updateViewWhenGetDataSuccessful:(jobModel*)job
{
    //实现数据显示功能
    
    //设置title
    //取消所有的用户交互
    //    self.mainScrollView.userInteractionEnabled=NO;
    
    self.jobTitleTextField.text=[job getjobTitle];
    
    
    //设置时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    [[job getjobEndTime] formattedTime];
    //设置时间
    self.beginTimeLabel.text=[formatter stringFromDate:[job getjobBeginTime]];
    self.endTimeLabel.text=[formatter stringFromDate:[job getjobEndTime]];
    BeginTime=[job getjobBeginTime];
    endTime=[job getjobEndTime];
    //设置工作可选时间,需要反向解析
    NSArray *jobworkTime=[job getjobWorkTime];
    for (NSObject *obj in jobworkTime) {
        NSString *intString=[NSString stringWithFormat:@"%@",obj];
        int i=[intString intValue];
        if (i>21 && i<0) {
            break;
        }
        selectFreeData[i]=true;
    }
    [self.selectedCollectionView reloadData];
    collectionViewDataArray=jobworkTime;
    workTimeFlag=YES;
    
    
    //设置工作类型
    NSMutableDictionary *typeForReanlysis=[NSMutableDictionary dictionary];
    NSArray *keyword=[typeSelectedDict allKeys];
    for (NSString *value in keyword) {
        [typeForReanlysis setObject:value forKey:[typeSelectedDict objectForKey:value]];
    }
    
    NSMutableDictionary *paymentForReanlysis=[NSMutableDictionary dictionary];
    NSArray *keyword1=[paymentSelectedDict allKeys];
    for (NSString *value in keyword1) {
        [paymentForReanlysis setObject:value forKey:[paymentSelectedDict objectForKey:value]];
    }
    NSMutableDictionary *eduForReanlysis=[NSMutableDictionary dictionary];
    NSArray *keyword2=[eduDict allKeys];
    for (NSString *value in keyword2) {
        [eduForReanlysis setObject:value forKey:[eduDict objectForKey:value]];
    }
    //job getjobType 这块是NSArray   里面内容是number
    self.typeLabel.text=[typeForReanlysis objectForKey:[NSString stringWithFormat:@"%@",[job getjobType]]];
    TypeString=[typeForReanlysis objectForKey:[NSString stringWithFormat:@"%@",[job getjobType]]];
    //设置工作地点
    [self.jobPlaceLabel setTitle:[NSString stringWithFormat:@"%@ %@ %@",[job getjobWorkPlaceProvince],[job getjobWorkPlaceCity],[job getjobWorkPlaceDistrict]] forState:UIControlStateNormal];
    workPlaceFlag=TRUE;
    //默认设置
    [self.thisJob setjobWorkProvince:[NSString stringWithFormat:@"%@",[job getjobWorkPlaceProvince]]];
    [self.thisJob setjobWorkCity:[NSString stringWithFormat:@"%@",[job getjobWorkPlaceCity]]];
    [self.thisJob setjobWorkDistrict:[NSString stringWithFormat:@"%@",[job getjobWorkPlaceDistrict]]];
    //设置定位信息
    NSNumber *numberLon=[[job getjobWorkPlaceGeoPoint] objectAtIndex:0];
    NSNumber *numberLat=[[job getjobWorkPlaceGeoPoint] objectAtIndex:0];
    nowGeo=[[geoModel alloc]initWith:[numberLon doubleValue] lat:[numberLat doubleValue]];
    //设置默认信息
    [self.thisJob setgeomodel:nowGeo];
    //设置招募数量
    self.wantedNumTextField.text=[NSString stringWithFormat:@"%@",[job getjobRecruitNum]];
    //设置工资
    self.salaryTextField.text=[NSString stringWithFormat:@"%@",[job getjobSalaryRange]];
    //设置结算方式
    
    self.paymentMethodLabel.text=[paymentForReanlysis objectForKey:[NSString stringWithFormat:@"%@",[job getjobSettlementWay]]];
    paywayString=[paymentForReanlysis objectForKey:[NSString stringWithFormat:@"%@",[job getjobSettlementWay]]];
    //设置工作描述
    
    self.jobDescriptTextField.text=[NSString stringWithFormat:@"%@",[job getjobIntroduction]];
    
    //设置性别
    NSLog(@"%@",_radio_female.checked==YES?@"YES":@"NO");
    NSLog(@"%@",_radio_male.checked==YES?@"YES":@"NO");
    NSLog(@"%@",_radio_noDemand.checked==YES?@"YES":@"NO");
    if ([[job getjobGenderReq] isEqualToNumber:[NSNumber numberWithInt:0]])
    {//男
        [_radio_male setChecked:TRUE];
        
    }
    else if([[job getjobGenderReq] isEqualToNumber:[NSNumber numberWithInt:1]])
    {//女
        [_radio_female setChecked:YES];
    }
    else if([[job getjobGenderReq] isEqualToNumber:[NSNumber numberWithInt:2]])
    {//不限
        [_radio_noDemand setChecked:YES];
    }else
    {
        [_radio_noDemand setChecked:YES];
    }
    NSLog(@"%@",_radio_female.checked==YES?@"YES":@"NO");
    NSLog(@"%@",_radio_male.checked==YES?@"YES":@"NO");
    NSLog(@"%@",_radio_noDemand.checked==YES?@"YES":@"NO");
    //设置默认性别
    [self.thisJob setjobGenderReq:[job getjobGenderReq]];
    gender=[job getjobGenderReq];
    //设置年龄
    self.ageTextField.text=[NSString stringWithFormat:@"%@",[job getjobAgeStartReq]];
    self.ageMaxTextField.text=[NSString stringWithFormat:@"%@",[job getjobAgeEndReq]];
    
    
    //设置身高
    self.heightTextField.text=[NSString stringWithFormat:@"%@",[job getjobHeightStartReq]];
    self.heightMaxTextField.text=[NSString stringWithFormat:@"%@",[job getjobHeightEndReq]];
    
    //设置学历
    self.eduTitleLabel.text=[eduForReanlysis objectForKey:
                             [NSString stringWithFormat:@"%@",[job getjobDegreeReq]]];
    eduString=[eduForReanlysis objectForKey:
               [NSString stringWithFormat:@"%@",[job getjobDegreeReq]]];
    
    //设置联系人
    self.contactPersonLabel.text=[NSString stringWithFormat:@"%@",[job getjobContactName]];
    
    //设置联系电话
    self.contactPhone.text=[NSString stringWithFormat:@"%@",[job getjobPhone]];
    
    //设置详细地址
    self.addressTextField.text=[NSString stringWithFormat:@"%@",[job getjobWorkAddressDetail]];
    
    //设置logo, 图片
    NSString *imageUrl;
    NSString *url1;
    if ([job getjobEnterpriseImageURL]!=nil) {
        url1=[job getjobEnterpriseImageURL];
    }else if ([job getjobEnterpriseLogoURL]!=nil)
    {
        url1=[job getjobEnterpriseLogoURL];
    }
    if ([url1 length]>4) {
        if ([[url1 substringToIndex:4] isEqualToString:@"http"])
            imageUrl=url1;
    }
    if ([imageUrl length]>4) {
        self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.logoImageView.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.logoImageView];
        self.logoImageView.imageURL=[NSURL URLWithString:imageUrl];
        imageAddFlag=YES;
        [self.thisJob setjobEnterpriseImageURL:imageUrl];
    }else{
        self.logoImageView.image=[UIImage imageNamed:@"placeholder"];
    }
    
    //后台设置
    //    [self.thisJob setjobEnterpriseName:@"IBM"];
    //    [self.thisJob setjobEnterpriseIndustry:2];
    //    [self.thisJob setjobEnterpriseAddress:@"奥林匹克公园"];
    //    [self.thisJob setjobEnterpriseIntroduction:@"IBM"];
    //    [self.thisJob setjobEnterpriseImageURL:@"a"];
    //    [self.thisJob setjobEnterpriseLogoURL:@"b"];
    [self hideHud];
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
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    workTimeFlag=true;
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    if(selectFreeData[indexPath.row-7])
    {
        [self addjobWorkTime:(indexPath.row-7)];
    }
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


-(BOOL)checkFromBeforeUpLoad
{
    BOOL flag=false;
    if (nowGeo==nil) {
        ALERT(@"缺少定位信息，请重新点击定位");
        return flag;
    }
    //检查 Title
    if (self.jobTitleTextField.text==nil) {
        ALERT(@"标题不完整");
        return flag;
    }
    if (self.beginTimeLabel.text==nil) {
        ALERT(@"开始时间不完整");
        return flag;
    }
    if (self.endTimeLabel.text==nil) {
        ALERT(@"工作时间不完整");
        return flag;
    }if (self.typeLabel.text==nil || TypeString==nil) {
        ALERT(@"工作类型不完整");
        return flag;
    }
    //检验数字
    if (self.wantedNumTextField.text==nil) {
        ALERT(@"招募数量不完整");
        return flag;
    }else if(![RegexTest isIntNumber:self.wantedNumTextField.text]){
        ALERT(@"招募数量有错误");
        return flag;
    }
    if(self.salaryTextField.text==nil)
    {
        ALERT(@"薪资输入不完整");
        return flag;
        
    }else if(![RegexTest isIntNumber:self.salaryTextField.text])
    {
        ALERT(@"输入有错误");
        return flag;
    }
    
    if (self.paymentMethodLabel.text==nil || paywayString==nil) {
        ALERT(@"结算方式不完整");
        return flag;
    }
    
    if (self.jobDescriptTextField.text==nil) {
        ALERT(@"工作描述不完整");
        return flag;
    }
    
    
    if (self.ageTextField.text==nil | self.ageMaxTextField.text==nil) {
        ALERT(@"年龄输入有错误");
        return flag;
    }else if(![RegexTest isIntNumber:self.ageTextField.text] || ![RegexTest isIntNumber:self.ageMaxTextField.text])
    {
        ALERT(@"年龄有错误，请输入数字");
        return flag;
    }
    
    if (self.heightTextField.text==nil | self.heightMaxTextField.text==nil) {
        ALERT(@"身高资料不完整");
        return flag;
    }
    else if(![RegexTest isIntNumber:self.heightTextField.text]||![RegexTest isIntNumber:self.heightMaxTextField.text])
    {
        ALERT(@"身高请输入数字,请仔细检查");
        return flag;
    }
    
    
    if(self.eduTitleLabel.text==nil || eduString==nil)
    {
        ALERT(@"教育资料不完整");
        return flag;
    }
    
    if(self.contactPersonLabel.text==nil)
    {
        ALERT(@"资料不完整");
        return flag;
    }
    
    if (self.contactPhone.text==nil) {
        ALERT(@"资料不完整");
        return flag;
    }else if(![RegexTest isIntNumber:self.contactPhone.text])
    {
        ALERT(@"电话输入有错误,请仔细检查");
        return flag;
    }
    if (self.addressTextField.text==nil) {
        ALERT(@"工作地址不完整");
        return flag;
    }
    
    if (!workTimeFlag ||collectionViewDataArray==nil) {
        ALERT(@"请设置工作时间");
        return flag;
    }
    
    if (self.jobDescriptTextField.text==nil) {
        ALERT(@"请输入工作描述");
        return flag;
    }
    if (!workPlaceFlag) {
        ALERT(@"请输入工作位置");
        return flag;
    }
    
    
    flag=TRUE;
    return flag;
}

//发布
- (IBAction)publishAction:(id)sender {
    if ([self checkFromBeforeUpLoad]) {
        [self preparePublish:1];
    }
}


-(void)preparePublish:(int)flag
{
    
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    
    NSString *com_id=[mysettings objectForKey:@"currentUserObjectId"];
    
    if (com_id==nil) {
        ALERT(@"请先登录");
        return;
    }
    
    
    createJobModel *newJob=[[createJobModel alloc]init];
    
    
    //设置id
    [newJob setenterprise_id:com_id];
    [self.thisJob setenterprise_id:com_id];
    if (![self checkFromBeforeUpLoad]) {
        ALERT(@"上传失败，数据输入错误");
        return;
    }
    
    
    //设置geo
    if (nowGeo!=nil) {
        [self.thisJob setgeomodel:nowGeo];
    }
    //设置title
    [self.thisJob setjobTitle:self.jobTitleTextField.text];
    
    //设置时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    if(self.beginTimeLabel.text)
    {
        NSLog(@"%@",self.beginTimeLabel.text);
        NSDate *dateTime = [formatter dateFromString:self.beginTimeLabel.text];
        
        [self.thisJob setjobBeginTime:dateTime];
    }
    else
    {
        [self.thisJob setjobBeginTime:[NSDate date]];
    }
    
    if (self.endTimeLabel.text) {
        
        NSLog(@"%@",self.endTimeLabel.text);
        
        NSDate *endDateTime = [formatter dateFromString:self.endTimeLabel.text];
        [newJob setjobEndTime:endDateTime];
        [self.thisJob setjobEndTime:endDateTime];
    }
    else
    {
        [newJob setjobEndTime:[NSDate date]];
        [self.thisJob setjobEndTime:[NSDate date]];
    }
    
    //设置工作可选时间
    [self.thisJob setjobWorkTime:collectionViewDataArray];;
    
    
    
    //设置工作类型 交给选择器设置
    //    [self.thisJob setjobType:0];
    
    //设置工作地点，交给定位设置
    
    //设置招募数量
    
    [self.thisJob setjobRecruitNum:[self.wantedNumTextField.text intValue]];
    
    //设置工资
    [self.thisJob setjobSalary:[self.salaryTextField.text intValue]];
    
    //设置结算方式,交给选择器设置
    //    [self.thisJob setjobSettlementWay:0];
    
    //设置工作描述
    
    [self.thisJob setjobIntroduction:self.jobDescriptTextField.text];
    
    //设置性别  交给性别选择器设置  默认是2.
    
    
    //设置年龄
    [self.thisJob setjobAgeStartReq:[self.ageTextField.text intValue]];
    [self.thisJob setjobAgeEndReq:[self.ageMaxTextField.text intValue]];
    
    //设置身高
    [self.thisJob setjobHeightStartReq:[self.heightTextField.text intValue]];
    [self.thisJob setjobHeightEndReq:[self.heightMaxTextField.text intValue]];
    
    //设置学历
    [self.thisJob setjobDegreeReq:1];
    
    //设置联系人
    [self.thisJob setjobContactName:self.contactPersonLabel.text];
    
    //设置联系电话
    [self.thisJob setjobContactPhone:self.contactPhone.text];
    
    //设置详细地址
    [self.thisJob setjobWorkAddressDetail:self.addressTextField.text];
    
    
    
    
    //后台设置
    if (!imageAddFlag) {
        [self.thisJob setjobEnterpriseImageURL:@"null"];
    }
    
    //    [self.thisJob setjobEnterpriseName:@"IBM"];
    [self.thisJob setjobEnterpriseName:[mysettings objectForKey:CURRENTUSERNAME]];
    
    [self.thisJob setjobEnterpriseIndustry:0];
    
    [self.thisJob setjobEnterpriseAddress:[mysettings objectForKey:CURRENTUSERADDRESS]];
    
    [self.thisJob setjobEnterpriseIntroduction:[mysettings objectForKey:CURRENTINTRODUCTION]];
    //设置logo
    //    [self.thisJob setjobEnterpriseLogoURL:@"b"];
    [self.thisJob setjobEnterpriseLogoURL:[mysettings objectForKey:CURRENTLOGOURL]];
    
    //    [self.thisJob setjobEnterpriseName:[mysettings objectForKey:CURRENTUSERREALNAME]];
    //    [self.thisJob setjobEnterpriseIntroduction:[mysettings objectForKey:CURRENTINTRODUCTION]];
    
    //    NSString *comLogoUrl=[mysettings objectForKey:CURRENTLOGOURL];
    //    [self.thisJob setjobEnterpriseLogoURL:comLogoUrl];
    
    //jobImage
    //    [self.thisJob setjobEnterpriseImageURL:@"a"];
    
    //    if ([self.thisJob getIsOK]!=DATAOK) {
    ////        NSString *error=[self.thisJob notOKResult:[self.thisJob getIsOK]];
    ////        ALERT(error);
    //    }
    if(0);
    else{
        if (1==flag) {
//            [self.thisJob getBaseString]
            NSLog(@"BaseString: %@",[self.thisJob getBaseString]);
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认发布职位" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"发布", nil];
            alert.tag=12301;
            [alert show];
        }
//        else{
//            NSLog(@"BaseString: %@",[self.thisJob getBaseString]);
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[self.thisJob getBaseString] delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"发布职位模板", nil];
//            alert.tag=12300;
//            [alert show];
//        }
    }
    
    
}

-(void)doPublishTemplate
{
    [self showHudInView:self.mainScrollView hint:@"发布中.."];
    [netAPI createJobTemplate:self.thisJob withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            NSLog(@"新建job id = %@",[oprationModel getOprationID]);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"职位模板创建成功，是否现在发布" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在发布", nil];
            alert.tag=123400;
            [alert show ];
        }
        else
        {
            NSLog(@"新建job id = %@",[oprationModel getOprationID]);
            NSString *errorString=[NSString stringWithFormat:@"发布失败,原因:%@",[oprationModel getInfo]];
            ALERT(errorString);
        }
    }];
}


-(void)doPublishJob
{
    [self showHudInView:self.mainScrollView hint:@"发布中.."];
    [netAPI createJob:self.thisJob withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            NSLog(@"新建job id = %@",[oprationModel getOprationID]);
            ALERT(@"发布成功，请前往“我的发布”中查看！");
#warning （待完成）职位发布完成后操作，比如设置下我的发布列表；通知更新
            [self.navigationController popToRootViewControllerAnimated:YES];
//            RESideMenu *sideMune=[RESideMenu sharedInstance];
//            [sideMune setBadgeView:3 badgeText:@"1"];
        }
        else
        {
            NSLog(@"新建job id = %@",[oprationModel getOprationID]);
            NSString *errorString=[NSString stringWithFormat:@"发布失败,原因:%@",[oprationModel getInfo]];
            ALERT(errorString);
        }
    }];
    
    
    
    
}
#pragma --mark  alertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 12300:
        {
            if (buttonIndex==1) {
                
                //确认发布
                [self doPublishTemplate];
            }
        }
            break;
            
        case 12301:
        {
            if (buttonIndex==1) {
                
                //确认发布
                [self doPublishJob];
            }
            
            break;
        }
        case 123400:
        {
            
            if (buttonIndex==1) {
                //确认发布新job
                [self doPublishJob];
            }
            break;
        }
        default:
            break;
    }
}
//*********************dropdownList********************//
#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index row:(NSInteger)row
{
    //NSLog(@"选了section:%d ,index:%d, row:%d",section,index,row);
    if (row==-1) {
        NSLog(@"%@",[chooseArray[section][index] objectForKey:@"type"]);
    }else
        NSLog(@"%@",[[chooseArray[section][index] objectForKey:@"detail"]objectAtIndex:row]);
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}

-(NSInteger)numberOfRowsOfPart1InSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}

-(NSInteger)numberOfRowsOfPart2InSection:(NSInteger)section Row:(NSInteger)row
{
    if ([[chooseArray[section][row] objectForKey:@"detailExist"] isEqualToString:@"1"]) {
        NSArray *arr=[chooseArray[section][row] objectForKey:@"detail"];
        return [arr count];
    }
    else
        return 0;
}

-(NSString *)titleOfPart1InSection:(NSInteger)section index:(NSInteger) index{
    return [chooseArray[section][index] objectForKey:@"type"];
}

-(NSString *)titleOfPart2InSection:(NSInteger)section index:(NSInteger) index row:(NSInteger)row{
    return [[chooseArray[section][index] objectForKey:@"detail"]objectAtIndex:row];
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

-(void)showJobList
{
    JobPublishedListViewController *listVC=[[JobPublishedListViewController alloc]init];
    
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma --mark  DatePicker  Method


-(void)datePickerInitwithTag:(NSInteger)tag
{
    
    //设置默认显示的时间
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    now=[NSDate date];
    //    comps = [calendar components:unitFlags fromDate:now];
    self.datePicker=[[ZHPickView alloc]initDatePickWithDate:now datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    [self.datePicker show];
}

#pragma --  ZHPickView Delegate Method

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSLog(@"pickView:%@",resultString);
    switch (pickView.tag) {
        case BeginDatePickViewTag:
        {
            
            NSString *result=[resultString substringToIndex:(resultString.length-15)];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            BeginTime=[dateformatter dateFromString:result];
            if (endTime!=nil) {
                if ([endTime isEarlierThanDate:BeginTime]) {
                    ALERT(@"提示:工作结束时间早于开始时间");
                    break;
                }
            }
            self.beginTimeLabel.text=result;
            break;
        }
        case EndDatePickViewTag:
        {
            NSString *result=[resultString substringToIndex:(resultString.length-15)];
            if (BeginTime==nil) {
                ALERT(@"请先选择开始时间");
                break;
            }
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            endTime=[dateformatter dateFromString:result];
            
            if ([endTime isEarlierThanDate:BeginTime]) {
                ALERT(@"提示:工作结束时间早于开始时间");
                break;
            }
            self.endTimeLabel.text=result;
            break;
        }
        case TypePickViewTag:
        {
            self.typeLabel.text=resultString;
            TypeString=resultString;
            [self.thisJob setjobType:[[typeSelectedDict objectForKey:resultString] intValue]];
            break;
        }
        case EduTitlePickViewTag:
        {
            self.eduTitleLabel.text=resultString;
            eduString=resultString;
            [self.thisJob setjobDegreeReq:[[eduDict objectForKey:resultString] intValue]];
            break;
        }
        case PaymentPickViewTag:
        {
            self.paymentMethodLabel.text=resultString;
            paywayString=resultString;
            [self.thisJob setjobSettlementWay:[[paymentSelectedDict objectForKey:resultString] intValue]];
            break;
        }
        default:
            break;
    }
}

- (IBAction)showBeginTimeAction:(id)sender {
    [self datePickerInitwithTag:BeginDatePickViewTag];
}

- (IBAction)showEndTimeAction:(id)sender {
    [self datePickerInitwithTag:EndDatePickViewTag];
    
}



-(void)paymentPickViewInitWithTag:(NSInteger)tag
{
    NSArray *keywordArray=[paymentSelectedDict allKeys];
    self.datePicker=[[ZHPickView alloc]initPickviewWithArray:keywordArray isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    [self.datePicker show];
    
}

- (IBAction)selectedPaymentAction:(id)sender {
    
    [self paymentPickViewInitWithTag:PaymentPickViewTag];
    
    
}

-(void)eduPickViewInitWithTag:(NSInteger)tag
{
    if(eduDict==nil) eduDict=@{@"不限":@"1",@"初中及以下":@"2",@"高中":@"3",@"大专":@"4",@"本科":@"5",@"硕士":@"6",@"博士及以上":@"7"};
    
    
    NSArray *keywordArray=[eduDict allKeys];
    self.datePicker=[[ZHPickView alloc]initPickviewWithArray:keywordArray isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    [self.datePicker show];
    
}

- (IBAction)selectedEduAction:(id)sender {
    [self eduPickViewInitWithTag:EduTitlePickViewTag];
}



#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
    gender=1;
    if ([radio.titleLabel.text isEqualToString:@"男"]) {
        [self.thisJob setjobGenderReq:0];
    }
    else if ([radio.titleLabel.text isEqualToString:@"女"]) {
        [self.thisJob setjobGenderReq:1];
    }
    else if ([radio.titleLabel.text isEqualToString:@"不限"]) {
        [self.thisJob setjobGenderReq:2];
    }
}

- (IBAction)selectDistrictAction:(id)sender {
    [self cancelLocatePicker];
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    self.locatePicker.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    
    [self.locatePicker showInView:self.view];
}

- (IBAction)findLocationBtnAction:(id)sender {
    [self startLocationService];
}

- (IBAction)selectedTypeAction:(id)sender {
    [self typePickViewInitWithTag:TypePickViewTag];
}

-(void)typePickViewInitWithTag:(NSInteger)tag
{
    if (typeSelectedDict==nil) {
        typeSelectedDict=@{@"模特/礼仪":@"0", @"促销/导购":@"1", @"销售":@"2" ,@"传单派发":@"3" ,@"安保":@"4" ,@"钟点工":@"5", @"法律事务":@"6", @"服务员":@"7" ,@"婚庆":@"8", @"配送/快递":@"9", @"化妆":@"10", @"护工/保姆":@"11", @"演出":@"12", @"问卷调查":@"13", @"志愿者":@"14" ,@"网络营销":@"15" ,@"导游":@"16", @"游戏代练":@"17", @"家教":@"18", @"软件/网站开发":@"19", @"会计":@"20", @"平面设计/制作":@"21", @"翻译":@"22", @"装修":@"23", @"影视制作":@"24", @"搬家":@"25", @"其他":@"26"};
    }
    NSArray *keywordArray=[typeSelectedDict allKeys];
    self.datePicker=[[ZHPickView alloc]initPickviewWithArray:keywordArray isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    [self.datePicker show];
}


-(void)addjobWorkTime:(NSInteger)choiceTimeInt
{
    if(collectionViewDataArray==nil)
        collectionViewDataArray=[NSArray array];
    NSNumber *numFromInt=[NSNumber numberWithInteger:choiceTimeInt];
    collectionViewDataArray=[collectionViewDataArray arrayByAddingObject:numFromInt];
}



#pragma --mark  回收软键盘
//点击背景收回软键盘

//点击return收回软键盘
- (IBAction)TextField_DidEndOnExit:(id)sender {
    // 隐藏键盘.
    
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


#pragma --mark  获取地理位置
-(void)startLocationService
{
    
    jobPublicationViewController *__weak weakSelf=self;
    AJLocationManager *ajLocationManager=[AJLocationManager shareLocation];
    [self showHudInView:self.mainScrollView hint:@"定位中.."];
    [ajLocationManager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location=[AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        
        //
        
        
        //设置定位，
        geoModel *geo = [[geoModel alloc]initWith:locationCorrrdinate.longitude lat:locationCorrrdinate.latitude];
        //
        nowGeo=geo;
        //发起逆地理编码
        [weakSelf.search AMapReGoecodeSearch: regeoRequest];
    } error:^(NSError *error) {
        [weakSelf hideHud];
        ALERT(error.description);
        [weakSelf errorHideHudAfterDelay];
    }];
}

-(void)errorHideHudAfterDelay
{
    [self hideHud];
    ALERT(@"请求超时");
    self.jobPlaceLabel.titleLabel.text=@"请手动选择";
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self hideHud];
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        
        [self.jobPlaceLabel setTitle:[NSString stringWithFormat:@"%@ %@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district]
                            forState:UIControlStateNormal];
        [self.thisJob setjobWorkProvince:response.regeocode.addressComponent.province];
        if(response.regeocode.addressComponent.city!=nil) [self.thisJob setjobWorkCity:response.regeocode.addressComponent.city];
        else [self.thisJob setjobWorkCity:response.regeocode.addressComponent.province];
        
        [self.thisJob setjobWorkDistrict:response.regeocode.addressComponent.district];
        workPlaceFlag=TRUE;
    }
}

-(void)editJob{
    ALERT(@"开始编辑");
    [self canEditMode];
}


#pragma --mark  添加照片
- (IBAction)AddImageAction:(id)sender {
    //照片逻辑
    imageAddFlag=YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"选择本地图片",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}



-(void)addJobPicAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"选择本地图片",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
}

//action
//tag == 0 为选择图片按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法使用照相功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
    }
    else if (actionSheet.tag==1) {
        
    }
}

//action响应事件
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(BOOL)writeImageToDoc:(UIImage*)image{
    BOOL result;
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        fileTempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",[baseAPP getUsrID],[FileNameGenerator getNameForNewFile]]];
        result = [UIImagePNGRepresentation(image)writeToFile:fileTempPath atomically:YES];
    }
    return result;
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


//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    UIImage *temp = image;
    if (image.size.height > PIC_HEIGHT || image.size.width>PIC_WIDTH) {
        CGSize size = CGSizeMake(320, 320);
        temp = [self scaleToSize:image size:size];
    }
    picker = Nil;
    [self dismissModalViewControllerAnimated:YES];
    if (![self writeImageToDoc:image]) {
        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"写入文件夹错误,请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alterTittle show];
    }else{
        //添加图片
        //        imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
        //        btnPic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //        btnPic.titleLabel.font = [UIFont systemFontOfSize:13];
        //        UIImage *darkTemp = [temp rt_darkenWithLevel:0.5f];
        //        [btnPic setBackgroundImage:darkTemp forState:UIControlStateNormal];
        //        [btnPic setFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
        //        [addedPicArray addObject:btnPic];
        //        [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
        //        [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [btnPic setStatus:uplaoding];
        //        [self.picScrollView addSubview:btnPic];
        //
        //        for (imageButton *btn in addedPicArray) {
        //            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        //            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
        //            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
        //            [positionAnim setDelegate:self];
        //            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //            [positionAnim setDuration:0.25f];
        //            [btn.layer addAnimation:positionAnim forKey:nil];
        //
        //            [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
        //        }
        //        [self refreshScrollView];
        
        //        if ([addedPicArray count]>1)
        //        {
        //            ALERT(@"请选择一张图片");
        //            return;
        //        }
        self.logoImageView.image=temp;
        //上传图片
        [BmobFile filesUploadBatchWithPaths:@[fileTempPath]
                              progressBlock:^(int index, float progress) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self showHudInView:self.view hint:[NSString stringWithFormat:@"上传:%ld％",(long)(progress*100)]];
                                      if (progress==1) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                      }
                                  });
                              } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                  if (isSuccessful) {
                                      NSString *imageTemp = Nil;
                                      for (int i = 0 ; i < array.count ;i ++) {
                                          BmobFile *file = array [i];
                                          imageTemp = [file url];
                                          if (imageTemp != Nil) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.thisJob setjobEnterpriseImageURL:imageTemp];
                                                  [MBProgressHUD showError:@"上传成功" toView:self.view];
                                              });
                                          }else{
                                              [self hideHud];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.thisJob setjobEnterpriseImageURL:@"null"];
                                                  [MBProgressHUD showError:@"上传失败" toView:self.view];
                                              });
                                          }
                                      }
                                  }else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.thisJob setjobEnterpriseImageURL:@"null"];
                                          [MBProgressHUD showError:@"上传失败" toView:self.view];
                                      });
                                  }
                              }];
    }
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)deletePicAction_uploadOKandfromNet:(imageButton *)sender{
    NSInteger btnindex = [sender restorationIdentifier].integerValue;
    imageButton *btn = [addedPicArray objectAtIndex:btnindex];
    [btn removeFromSuperview];
    for (imageButton *tempbtn in addedPicArray) {
        if ([tempbtn restorationIdentifier].intValue > btnindex) {
            [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue == btnindex) {
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue < btnindex) {
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [tempbtn.layer addAnimation:positionAnim forKey:nil];
            [tempbtn setCenter:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)];
        }
    }
    [addedPicArray removeObjectAtIndex:btnindex];
    [self refreshScrollView];
}

-(void)deletePicAction_uplaoding{
    
}

-(void)deletePicAction_uploaderror{
    
}


-(IBAction)deletePicAction:(imageButton *)sender{
    switch ([sender getStatus]) {
        case uploadOK:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        case uplaoding:
            [self deletePicAction_uplaoding];
            break;
        case uploaderror:
            [self deletePicAction_uploaderror];
            break;
        case fromNet:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        default:
            break;
    }
}
- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, PIC_HEIGHT+INSETS*2);
    [self.picScrollView setContentSize:contentSize];
    [self.picScrollView setContentOffset:CGPointMake(width<self.picScrollView.frame.size.width?0:width-self.picScrollView.frame.size.width, 0) animated:YES];
}




#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    province=picker.locate.state;
    city=picker.locate.city;
    district=picker.locate.district;
    NSString *addr=[NSString stringWithFormat:@"%@ %@ %@",province,city,district];
    [self.jobPlaceLabel setTitle:addr forState:UIControlStateNormal];
    if (province==nil && city!=nil) {
        [self.thisJob setjobWorkProvince:city];
    }
    else if (city==nil && province!=nil) {
        [self.thisJob setjobWorkCity:province];
    }else{
        
        [self.thisJob setjobWorkProvince:province];
        [self.thisJob setjobWorkCity:city];
        [self.thisJob setjobWorkDistrict:district];
        workPlaceFlag=TRUE;
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)cannotEditMode
{
    self.publishBtn.enabled=NO;
    self.jobPlaceLabel.enabled=NO;
    self.addImageBtn.enabled=NO;
    self.publishedAgainBtn.enabled=NO;
    [self.publishedAgainBtn setBackgroundColor:[UIColor grayColor]];
    self.jobInfo1View.userInteractionEnabled=NO;
    self.jobInfo2View.userInteractionEnabled=NO;
    self.jobInfo3View.userInteractionEnabled=NO;
    self.jobInfo4View.userInteractionEnabled=NO;
    self.jobInfo6View.userInteractionEnabled=NO;
}

-(void)canEditMode
{
    self.jobPlaceLabel.enabled=YES;
    self.addImageBtn.enabled=YES;
    self.publishedAgainBtn.enabled=YES;
    [self.publishedAgainBtn setBackgroundColor:[UIColor colorWithRed:0.98 green:0.41 blue:0.40 alpha:1.0]];
    self.jobInfo1View.userInteractionEnabled=YES;
    self.jobInfo2View.userInteractionEnabled=YES;
    self.jobInfo3View.userInteractionEnabled=YES;
    self.jobInfo4View.userInteractionEnabled=YES;
    self.jobInfo6View.userInteractionEnabled=YES;
    [self.publishedAgainBtn setTitle:@"再次发布" forState:UIControlStateNormal];
}

- (IBAction)publisedAgainAction:(id)sender {
    //    ALERT(@"再次发布");
    if ([self checkFromBeforeUpLoad]) {
        [self preparePublish:1];
    }
}
@end
