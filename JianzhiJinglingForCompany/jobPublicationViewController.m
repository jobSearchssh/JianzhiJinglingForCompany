//
//  jobPublicationViewController.m
//  JianzhiJinglingForCompany
//
//  Created by 郭玉宝 on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "jobPublicationViewController.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"
#import "JobPublishedListViewController.h"
#import "ZHPickView.h"
#import "QRadioButton.h"




#define BeginDatePickViewTag 20001
#define EndDatePickViewTag 20002
#define TypePickViewTag 70001
#define EduTitlePickViewTag 70002
#define PaymentPickViewTag 70003



static NSString *selectFreecellIdentifier = @"freeselectViewCell";
@interface jobPublicationViewController ()<DropDownChooseDataSource,DropDownChooseDelegate,ZHPickViewDelegate,QRadioButtonDelegate>
{
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
    
    
    //DropDownList dataSourceArray
    NSArray *chooseArray;
    
    //pickViewDatasource
    NSDictionary *eduDict;
    NSDictionary *typeSelectedDict;
    NSDictionary *paymentSelectedDict;
    
    QRadioButton *_radio1;
    QRadioButton *_radio2;
    QRadioButton *_radio3;
}

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
@property (weak, nonatomic) IBOutlet UITextField *jobDescriptTextField;

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


@property (weak, nonatomic) IBOutlet UILabel *jobPlaceLabel;

- (IBAction)findLocationBtnAction:(id)sender;

- (IBAction)selectedTypeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
@implementation jobPublicationViewController


-(void)dropDownInit
{
    NSMutableArray *chooseArray1=[[NSMutableArray alloc]initWithObjects:
                                  [[NSDictionary alloc]initWithObjectsAndKeys:@"全部分类",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"今日新单",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"美食",@"type",@"1",@"detailExist",@[@"全部",@"火锅",@"自助餐",@"西餐",@"烧烤/烤串",@"麻辣烫",@"日韩料理",@"蛋糕甜点",@"麻辣香锅",@"川湘菜",@"江浙菜",@"粤菜",@"西北/东北菜",@"京菜/鲁菜",@"云贵菜",@"东南亚菜",@"台湾菜",@"海鲜",@"小吃快餐",@"特色菜",@"汤/粥/炖菜",@"咖啡/酒吧",@"新疆菜",@"聚餐宴请",@"其他美食",@"清真菜"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"电影",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"酒店",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"休闲娱乐",@"type",@"1",@"detailExist",@[@"全部",@"KTV",@"亲子游玩",@"温泉",@"洗浴",@"洗浴/汗蒸",@"足疗按摩",@"景点郊游",@"游泳/水上乐园",@"游乐园",@"运动健身",@"采摘",@"桌游/电玩",@"密室逃脱",@"咖啡酒吧",@"演出赛事",@"DIY手工",@"真人CS",@"4D/5D电影",@"其他娱乐"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"生活服务",@"type",@"1",@"detailExist",@[@"全部",@"婚纱摄影",@"儿童摄影",@"个性写真",@"母婴亲子",@"体检保健",@"汽车服务",@"逛街购物",@"照片冲印",@"培训课程",@"鲜花婚庆",@"服装定制洗护",@"配镜",@"商场购物卡",@"其他生活"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"丽人",@"type",@"1",@"detailExist",@[@"全部",@"美发",@"美甲",@"美容美体",@"瑜伽/舞蹈"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"旅游",@"type",@"1",@"detailExist",@[@"全部",@"景点门票",@"本地/周边游",@"国内游",@"境外游",@"漂流"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"购物",@"type",@"1",@"detailExist",@[@"全部",@"女装",@"男装",@"内衣",@"鞋靴",@"箱包/皮具",@"家具日用",@"家纺",@"食品",@"饰品/手表",@"美妆/个护",@"电器/数码",@"母婴/玩具",@"运动/户外",@"本地购物",@"其他购物"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"抽奖",@"type",@"0",@"detailExist",nil]
                                  , nil];
    
    NSMutableArray *chooseArray2=[[NSMutableArray alloc]initWithObjects:
                                  [[NSDictionary alloc]initWithObjectsAndKeys:@"全城",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"热门商区",@"type",@"1",@"detailExist",@[@"全部",@"滨江道",@"塘沽城区",@"大悦城",@"经济开发区",@"白堤路/风荷园",@"小海地",@"五大道",@"静海县",@"大港油田",@"大港城区",@"汉沽城区",@"河东万达广场",@"天津站后广场",@"乐园道",@"新港"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"滨海新区",@"type",@"1",@"detailExist",@[@"全部",@"塘沽城区",@"经济开发区",@"小海地",@"五大道",@"大港油田",@"大港城区",@"大港学府路",@"汉沽城区",@"新港"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"南开区",@"type",@"1",@"detailExist",@[@"全部",@"大悦城",@"白堤路/风荷园",@"王顶堤/华苑",@"水上/天塔",@"时代奥城",@"长虹公园",@"南开公园",@"海光寺/六里台",@"南开大学",@"天拖地区",@"鞍山西道",@"乐天",@"咸阳路/黄河道",@"天佑路/西南角"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"和平区",@"type",@"1",@"detailExist",@[@"全部",@"滨江道",@"和平路",@"小白楼",@"鞍山道沿线",@"南市",@"五大道",@"西康路沿线",@"荣业大街",@"卫津路沿线"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"红桥区",@"type",@"1",@"detailExist",@[@"全部",@"芥园路/复兴路",@"丁字沽",@"凯莱赛/西沽",@"水木天成",@"天津西站",@"大胡同",@"鹏欣水游城",@"邵公庄",@"本溪路",@"天津之眼"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"河西区",@"type",@"1",@"detailExist",@[@"全部",@"小海地",@"体院北",@"图书大厦",@"梅江",@"永安道",@"尖山",@"佟楼",@"宾西",@"挂甲寺",@"友谊路",@"越秀路",@"南楼",@"下瓦房",@"乐园道",@"新业广场"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"河东区",@"type",@"1",@"detailExist",@[@"全部",@"中山门",@"大直沽",@"大王庄",@"工业大学",@"万新村",@"卫国道",@"二宫",@"大桥道",@"河东万达广场",@"天津站后广场"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"河北区",@"type",@"1",@"detailExist",@[@"全部",@"王串场/民权门",@"中山路",@"意大利风情区",@"天泰路/榆关道",@"狮子林大街",@"金钟河大街"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"津南区",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"东丽区",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"西青区",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"武清区",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"近郊",@"type",@"1",@"detailExist",@[@"全部",@"北辰区",@"蓟县",@"静海县",@"宝坻区"],@"detail",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"宁河县",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"武清区",@"type",@"0",@"detailExist",nil]
                                  , nil];
    NSMutableArray *chooseArray3=[[NSMutableArray alloc]initWithObjects:
                                  [[NSDictionary alloc]initWithObjectsAndKeys:@"智能排序",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"离我最近",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"评价最高",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"最新发布",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"人气最高",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"价格最低",@"type",@"0",@"detailExist",nil]
                                  ,[[NSDictionary alloc]initWithObjectsAndKeys:@"价格最高",@"type",@"0",@"detailExist",nil]
                                  , nil];
    
    chooseArray=[NSMutableArray arrayWithObjects:chooseArray1,chooseArray2,chooseArray3, nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainScrollView.delegate=self;
    [self.navigationItem setTitle:@"发布职位"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(showJobList)];
    [self.navigationItem.rightBarButtonItem setTitle:@"列表"];
    
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    [sourceImages addObject:[UIImage imageNamed:@"0.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"1.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"2.jpg"]];
    
//第一项
 
    self.jobInfo1View.autoresizesSubviews=YES;
    self.jobInfo1View.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.mainScrollView addSubview:self.jobInfo1View];
    
//第二项
    [self.jobInfo2View setFrame:CGRectMake(0,100,MainScreenWidth,40)];
    [self.mainScrollView addSubview:self.jobInfo2View];
    
//第三项  collectionView
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
   
    

    
    //第四项
    [self.jobInfo4View setFrame:CGRectMake(0,self.jobInfo3View.frame.origin.y+self.jobInfo3View.frame.size.height,[UIScreen mainScreen].bounds.size.width,MainScreenHeight*0.8)];

    self.dropDownList1= [[DropDownListView alloc] initWithFrame:CGRectMake(0,0,MainScreenWidth, 40) dataSource:self delegate:self];
    self.dropDownList1.backgroundColor=[UIColor lightGrayColor];
    self.dropDownList1.mSuperView = self.jobInfo4View;
    [self.jobInfo4View addSubview:self.dropDownList1];
    
    
    [self.mainScrollView addSubview:self.jobInfo4View];
    
    
    
    //第五个buttonView
    
    [self.publishBtnView setFrame:CGRectMake(0,self.jobInfo4View.frame.origin.y+self.jobInfo4View.frame.size.height,[UIScreen mainScreen].bounds.size.width,self.publishBtn.frame.size.height)];
    
    [self.mainScrollView addSubview:self.publishBtnView];
    
    //设置最终长度
    [self.mainScrollView setContentSize:CGSizeMake(0,self.publishBtnView.frame.origin.y+self.publishBtnView.frame.size.height)];
    
    
    
    //添加PickView 响应时间
    _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.frame = CGRectMake(self.genderLabel.frame.origin.x+self.genderLabel.frame.size.width+10, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio1 setTitle:@"男" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.frame = CGRectMake(_radio1.frame.origin.x+_radio1.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio2 setTitle:@"女" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio2];
    
    _radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio3.frame = CGRectMake(_radio2.frame.origin.x+_radio2.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
    [_radio3 setTitle:@"不限" forState:UIControlStateNormal];
    [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.jobInfo4View addSubview:_radio3];
    
    
}


- (void)viewWillLayoutSubviews{
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    //layoutRadioButton
     _radio1.frame = CGRectMake(self.genderLabel.frame.origin.x+self.genderLabel.frame.size.width+10, self.genderLabel.frame.origin.y-10, 50, 40);
     _radio2.frame = CGRectMake(_radio1.frame.origin.x+_radio1.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
     _radio3.frame = CGRectMake(_radio2.frame.origin.x+_radio2.frame.size.width, self.genderLabel.frame.origin.y-10, 50, 40);
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

- (IBAction)publishAction:(id)sender {
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
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
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
            self.beginTimeLabel.text=resultString;
            break;
            
        case EndDatePickViewTag:
            self.endTimeLabel.text=resultString;
            break;
        case TypePickViewTag:
            self.typeLabel.text=resultString;
            break;
        case EduTitlePickViewTag:
            self.eduTitleLabel.text=resultString;
            break;
        case PaymentPickViewTag:
            self.paymentMethodLabel.text=resultString;
            break;
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
    if(paymentSelectedDict==nil) paymentSelectedDict=@{@"面议":@0,@"日结":@1,@"周结":@2,@"月结":@3,@"项目结":@4};
    NSArray *keywordArray=[paymentSelectedDict allKeys];
    self.datePicker=[[ZHPickView alloc]initPickviewWithArray:keywordArray isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    [self.datePicker show];

}




- (IBAction)selectedPaymentAction:(id)sender {
    
    
    
    
}

-(void)eduPickViewInitWithTag:(NSInteger)tag
{
    if(eduDict==nil) eduDict=@{@"不限":@1,@"初中及以下":@2,@"高中":@3,@"大专":@4,@"本科":@5,@"硕士":@6,@"博士及以上":@7};
    
    
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
}

- (IBAction)findLocationBtnAction:(id)sender {
    
    
    
    
    
}

- (IBAction)selectedTypeAction:(id)sender {
    [self typePickViewInitWithTag:TypePickViewTag];
}

-(void)typePickViewInitWithTag:(NSInteger)tag
{
    if (typeSelectedDict==nil) {
        typeSelectedDict=@{@"模特/礼仪":@0, @"促销/导购":@1, @"销售":@2 ,@"传单派发":@3 ,@"安保":@4 ,@"钟点工":@5, @"法律事务":@6, @"服务员":@7 ,@"婚庆":@8, @"配送/快递":@9, @"化妆":@10, @"护工/保姆":@11, @"演出":@12, @"问卷调查":@13, @"志愿者":@14 ,@"网络营销":@15 ,@"导游":@16, @"游戏代练":@17, @"家教":@18, @"软件/网站开发":@19, @"会计":@20, @"平面设计/制作":@21, @"翻译":@22, @"装修":@23, @"影视制作":@24, @"搬家":@25, @"其他":@26};
    }
    
    
    NSArray *keywordArray=[typeSelectedDict allKeys];
    
    self.datePicker=[[ZHPickView alloc]initPickviewWithArray:keywordArray isHaveNavControler:NO];
    self.datePicker.tag=tag;
    self.datePicker.delegate=self;
    
    [self.datePicker show];
}

@end
