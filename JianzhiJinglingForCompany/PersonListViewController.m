//
//  PersonListViewController.m
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "PersonListViewController.h"
#import "TableViewCell.h"
#import "netAPI.h"
#import "MJRefresh.h"
#import "MLResumePreviewVC.h"
#import "UIViewController+HUD.h"
#import <MAMapKit/MAMapKit.h>
#import "NSDate+Category.h"
#import "AJLocationManager.h"
#import "geoModel.h"
#import "UIViewController+LoginManager.h"
#define MyFavoriteTableViewFlag 0
#define MyAppliedTableViewFlag 1
#define UnhandledTableViewFlag 2

@interface PersonListViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    NSInteger pageSizeNum;
    NSInteger MyFavoritePageNum;
    NSInteger MyAppliedPageNum;
    NSInteger UnhandledPageNum;
    NSMutableArray * pageCountArray;
    
    geoModel *rightNowGPS;
    
    BOOL isfirstLoadData;
    NSInteger tableViewFlag;
    
    NSString *selectedUserId;
    NSIndexPath *selectedCellRow;
}
@property (nonatomic,strong)NSMutableArray *faviriteDataSource;
@property (nonatomic,strong)NSMutableArray *appliedDataSource;
@property (nonatomic,strong)NSMutableArray *unhandledDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//UISegmentedController
@property (strong,nonatomic)UISegmentedControl *segement;
@end

@implementation PersonListViewController
@synthesize tableView=_tableView;


#pragma --mark  单例模式写法
/**
 步骤:
 1.一个静态变量_inastance
 2.重写allocWithZone, 在里面用dispatch_once, 并调用super allocWithZone
 3.自定义一个sharedXX, 用来获取单例. 在里面也调用dispatch_once, 实例化_instance
 -----------可选------------
 4.如果要支持copy. 则(先遵守NSCopying协议)重写copyWithZone, 直接返回_instance即可.
 
  当在MRC下需要覆盖一些MRC中的内存管理方法：
 *- (id)retain.  单例中不需要增加引用计数器.return self.
 *- (id)autorelease.  只有堆中的对象才需要.单例中不需要.return self.
 *- (NSUInteger)retainCount.(可写可不写,防止引起误解).单例中不需要修改引用计数，返回最大的无符号整数即可.return UINT_MAX;
 *- (oneway void)release.不需要release.直接覆盖,什么也不做.
 
 */
//储存唯一实例
static PersonListViewController *thisVC;
//保证init初始化化都相同
+(PersonListViewController*)shareSingletonInstance
{
    //改写法为懒汉式写法
//    if (thisVC==nil) {
//        thisVC=[[self alloc]init];
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thisVC=[[PersonListViewController alloc]init];
    });
    return thisVC;
}
//重写allocWithZone方法，保证分配内存alloc时都相同
//+(id)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        thisVC=[super allocWithZone:zone];
//    });
//    return thisVC;
//}

//保证copy时都相同
-(id)copyWithZone:(NSZone*)zone
{
    return thisVC;
}







#pragma --mark 其他写法

-(void)segementedControlInit
{
    self.segement=[[UISegmentedControl alloc]initWithItems:@[@"我的关注",@"已同意",@"未处理"]];
    self.segement.selectedSegmentIndex=MyFavoriteTableViewFlag;
    self.navigationItem.titleView=self.segement;
    [self.segement addTarget:self
                      action:@selector(segementedChange)
            forControlEvents:UIControlEventValueChanged];
}

-(void)segementedChange
{
    switch (self.segement.selectedSegmentIndex) {
        case MyFavoriteTableViewFlag:
            NSLog(@"selected:%d",0);
            tableViewFlag=MyFavoriteTableViewFlag;
            [self.tableView reloadData];
            break;
        case MyAppliedTableViewFlag:
            if (isfirstLoadData) {
                [self loadUnhandledDatafromIndex:1 Length:pageSizeNum];
                isfirstLoadData=NO;
                
            }
            NSLog(@"selected:%d",1);
            tableViewFlag=MyAppliedTableViewFlag;
            [self.tableView reloadData];
            break;
        case UnhandledTableViewFlag:
            NSLog(@"selected:%d",2);
            if (isfirstLoadData) {
                [self loadUnhandledDatafromIndex:1 Length:pageSizeNum];
                isfirstLoadData=NO;
            }
            tableViewFlag=UnhandledTableViewFlag;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
    }
    isfirstLoadData=YES;
    [self tableViewInit];
    [self segementedControlInit];
}

- (void)tableViewInit{
    pageSizeNum=10;
    //初始化pageSize大小
    pageCountArray=[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
//    _tableView.scrollEnabled=YES;
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self loadDataWhenFirst];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideHud];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}


-(void)loadDataWhenFirst
{   [self showHudInView:self.tableView hint:@"加载中.."];
    [self loadFavorableDatafromIndex:1 Length:pageSizeNum];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray;
    switch (tableViewFlag) {
        case MyFavoriteTableViewFlag:
            dataArray=self.faviriteDataSource;
            break;
        case MyAppliedTableViewFlag:
            dataArray=self.appliedDataSource;
            break;
        case UnhandledTableViewFlag:
            dataArray=self.unhandledDataSource;
            break;
    }
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"TableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
     NSLog(@"%ld",indexPath.row);
    //清楚复用时的数据
    cell.usrImage.image=[UIImage imageNamed:@"placeholder"];
    
    //重新设置
    userModel *user=[dataArray objectAtIndex:indexPath.row];
    cell.usrNameLabel.text=[user getuserName];
    cell.usrJobReq.text=[user getuserExperience];
    cell.usrBreifIntro.text=[user getuserIntroduction];
#warning  image 字段没有添加
    cell.timeStamp.text=[[user getUpdateAt]timeIntervalDescription];
    
    if (1) {
        [self startLocationService:^{
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([rightNowGPS getLon],[rightNowGPS getLat]));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[user getuserLocationGeo] getLon],[[user getuserLocationGeo] getLat]));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            float kmDistance=distance/1000;
            cell.distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",kmDistance];
        }];
    }
//    else
//    {
//        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(nowLocation.y,nowLocation.x));
//        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[user getuserLocationGeo] getLon],[[user getuserLocationGeo] getLat]));
//        //2.计算距离
//        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
//        float kmDistance=distance/1000;
//        cell.distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",kmDistance];
//    }
    //设置头像
    NSString *imageUrl;
    NSArray *imageUrlArray=[user getImageFileURL];
    if ([imageUrlArray count]>0) {
        NSString *url1=[imageUrlArray objectAtIndex:0];
        if ([url1 length]>4) {
            if ([[url1 substringToIndex:4] isEqualToString:@"http"])
                imageUrl=url1;
        }
        if ([imageUrl length]>4) {
            cell.usrImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.usrImage.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.usrImage];
            cell.usrImage.imageURL=[NSURL URLWithString:imageUrl];
        }else{
            cell.usrImage.image=[UIImage imageNamed:@"placeholder"];
        }
    }
    cell.userId=[user getjob_user_id];
    cell.index=indexPath;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"trash"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] title:@"取消关注"];
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableViewFlag) {
        case MyFavoriteTableViewFlag:
        {
            if (self.faviriteDataSource!=nil) {
                return [self.faviriteDataSource count];
            }
            return 0;
            break;
        }
        case MyAppliedTableViewFlag:
        {
            if (self.appliedDataSource!=nil) {
                return [self.appliedDataSource count];
            }
            return 0;
            break;
        }
        case UnhandledTableViewFlag:
        {
            if (self.unhandledDataSource!=nil) {
                return [self.unhandledDataSource count];
            }
            return 0;
            break;
        }
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLResumePreviewVC *person=[[MLResumePreviewVC alloc]initWithNibName:@"MLResumePreviewVC" bundle:nil];
    NSArray *dataArray;
    switch (tableViewFlag) {
        case MyFavoriteTableViewFlag:
            dataArray=self.faviriteDataSource;
            person.stateFlag=InviteState;
            break;
        case MyAppliedTableViewFlag:
            dataArray=self.appliedDataSource;
            person.stateFlag=UnhanldedState;
            person.hideAcceptBtn=YES;
            break;
        case UnhandledTableViewFlag:
            dataArray=self.unhandledDataSource;
            person.stateFlag=UnhanldedState;
            break;
        default:
            break;
    }
    userModel *user=[dataArray objectAtIndex:indexPath.row];
    person.jobUserId=[user getjob_user_id];
    person.thisUser=user;
    person.hideRightBarButton=YES;
    person.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:person animated:YES];
}
- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
//*********************swipeableTableViewCell********************//
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            TableViewCell *cell1=cell;
            selectedUserId=cell1.userId;
            selectedCellRow=cell1.index;
            [self createCancelFavoriteReq:selectedUserId];
            break;
        }
        case 1:
        {
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            
            if(tableViewFlag==MyFavoriteTableViewFlag) return YES;
            if (tableViewFlag==MyAppliedTableViewFlag) return NO;
            if (tableViewFlag==UnhandledTableViewFlag) return NO;
            else return NO;
            break;
        default:
            break;
    }
    return YES;
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
//上拉加载更多
-(void)footerRefreshing
{

    switch (self.segement.selectedSegmentIndex) {
        case MyFavoriteTableViewFlag:
        {
            NSInteger nowNum=[self getPageStartIndexWithSegmentIndex:MyFavoriteTableViewFlag];
            NSInteger startNum=nowNum+1;
            [self loadFavorableDatafromIndex:startNum Length:pageSizeNum];
        }
            break;
        case MyAppliedTableViewFlag:
        {

            NSInteger nowNum=[self getPageStartIndexWithSegmentIndex:MyAppliedTableViewFlag];
            NSInteger startNum=nowNum+1;
            [self loadUnhandledDatafromIndex:startNum Length:pageSizeNum*2];
        }
            
            break;
        case UnhandledTableViewFlag:
        {
            NSInteger nowNum=[self getPageStartIndexWithSegmentIndex:UnhandledTableViewFlag];
            NSInteger startNum=nowNum+1;
            [self loadUnhandledDatafromIndex:startNum Length:pageSizeNum*2];
        }
            break;
        default:
            break;
    }
}

//下拉刷新全部，
-(void)headerRefreshing
{
    switch (self.segement.selectedSegmentIndex) {
        case MyFavoriteTableViewFlag:{
            NSInteger nowNum=[self getPageStartIndexWithSegmentIndex:MyFavoriteTableViewFlag];
//            if (isfirstLoadData || nowNum<1) {
//                [self updateFavorableDatafromIndex:1 Length:pageSizeNum];
//            }
//            else [self updateFavorableDatafromIndex:1 Length:nowNum];
            [self updateFavorableDatafromIndex:1 Length:pageSizeNum];
            break;
        }
        case MyAppliedTableViewFlag:
        {
//            NSInteger nowAppliedNum=[self getPageStartIndexWithSegmentIndex:MyAppliedTableViewFlag];
//            NSInteger nowUnhandlerNum=[self getPageStartIndexWithSegmentIndex:UnhandledTableViewFlag];
//            if (isfirstLoadData || nowAppliedNum<1) {
//                [self updateUnhandledDatafromIndex:1 Length:pageSizeNum];
//            }
//            else [self updateUnhandledDatafromIndex:1 Length:(nowAppliedNum+nowUnhandlerNum)];
            [self updateUnhandledDatafromIndex:1 Length:pageSizeNum];
            break;
        }
        case UnhandledTableViewFlag:
        {
//            NSInteger nowUnhandlerNum=[self getPageStartIndexWithSegmentIndex:UnhandledTableViewFlag];
//            NSInteger nowAppliedNum=[self getPageStartIndexWithSegmentIndex:MyAppliedTableViewFlag];
//            if (isfirstLoadData || nowUnhandlerNum<1) {
//                [self updateUnhandledDatafromIndex:1 Length:pageSizeNum];
//            }
//            else [self updateUnhandledDatafromIndex:1 Length:(nowUnhandlerNum+nowAppliedNum)];
            [self updateUnhandledDatafromIndex:1 Length:pageSizeNum];
            break;
        }
            break;
        default:
            break;
    }
}
-(void)updateFavorableDatafromIndex:(int)start Length:(int)length
{
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    PersonListViewController *__weak weakSelf=self;
    [netAPI queryStarJobUsers:com_id start:start length:length withBlock:^(userListModel *userListModel) {
        [weakSelf hideHud];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            
            if (self.faviriteDataSource==nil) {
                weakSelf.faviriteDataSource=[NSMutableArray arrayWithArray:[userListModel getuserArray]];
            }
            else
            {
                [weakSelf.faviriteDataSource removeAllObjects];
                [weakSelf.faviriteDataSource addObjectsFromArray:[userListModel getuserArray]];
            }
            [weakSelf.tableView reloadData];
            [weakSelf setPageCountArrayValue:[weakSelf.faviriteDataSource  count ]AtIndex:MyFavoriteTableViewFlag];
        }
        else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[userListModel getInfo]];
            ALERT(error);
            [weakSelf.tableView reloadData];
        }
    }];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}
-(void)updateUnhandledDatafromIndex:(int)start Length:(int)length
{
    
    if (self.unhandledDataSource==nil) {
        self.unhandledDataSource=[NSMutableArray array];
    }
    if (self.appliedDataSource==nil) {
        self.appliedDataSource=[NSMutableArray array];
    }
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    PersonListViewController *__weak weakSelf=self;
    [netAPI getMyRecruitUsers:com_id start:start length:length withBlock:^(userListModel *userListModel) {
        [weakSelf hideHud];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            NSArray *array=[userListModel getuserArray];
            [weakSelf.appliedDataSource removeAllObjects];
            [weakSelf.unhandledDataSource removeAllObjects];
            for (userModel *user in array) {
                NSString *usrCategory=[NSString stringWithFormat:@"%@", [user getApplyStatus]];
                if ([usrCategory isEqualToString:@"0"]) {
                    //未处理
                    [weakSelf.unhandledDataSource addObject:user];
                }
                else if([usrCategory isEqualToString:@"2"])
                    //已同意
                {
                    [weakSelf.appliedDataSource addObject:user];
                }
            }
            [weakSelf setPageCountArrayValue:[weakSelf.unhandledDataSource count] AtIndex:UnhandledTableViewFlag];
            [weakSelf setPageCountArrayValue:[weakSelf.appliedDataSource count] AtIndex:MyAppliedTableViewFlag];
            [weakSelf.tableView reloadData];
        }
        else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[userListModel getInfo]];
            ALERT(error);
            [weakSelf.tableView reloadData];
        }
    }];
//    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}



-(void)loadFavorableDatafromIndex:(int)start Length:(int)length
{
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    PersonListViewController *__weak weakSelf=self;
    [netAPI queryStarJobUsers:com_id start:start length:length withBlock:^(userListModel *userListModel) {
        [weakSelf hideHud];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            if (self.faviriteDataSource==nil) {
                weakSelf.faviriteDataSource=[NSMutableArray arrayWithArray:[userListModel getuserArray]];
            }
            else
            {
                [weakSelf.faviriteDataSource addObjectsFromArray:[userListModel getuserArray]];
            }
            [weakSelf.tableView reloadData];
            [weakSelf setPageCountArrayValue:[weakSelf.faviriteDataSource  count ]AtIndex:MyFavoriteTableViewFlag];
        }
        else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[userListModel getInfo]];
            ALERT(error);
            [weakSelf.tableView reloadData];
        }
    }];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}


-(void)loadUnhandledDatafromIndex:(int)start Length:(int)length
{
    
    if (self.unhandledDataSource==nil) {
        self.unhandledDataSource=[NSMutableArray array];
    }
    if (self.appliedDataSource==nil) {
        self.appliedDataSource=[NSMutableArray array];
    }
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    PersonListViewController *__weak weakSelf=self;
    [netAPI getMyRecruitUsers:com_id start:start length:length withBlock:^(userListModel *userListModel) {
        [weakSelf hideHud];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            NSArray *array=[userListModel getuserArray];
            for (userModel *user in array) {
                NSString *usrCategory=[NSString stringWithFormat:@"%@", [user getApplyStatus]];
                if ([usrCategory isEqualToString:@"0"]) {
                    //未处理
                    [weakSelf.unhandledDataSource addObject:user];
                }
                else if([usrCategory isEqualToString:@"2"])
                    //已同意
                {
                    [weakSelf.appliedDataSource addObject:user];
                }
            }
            [weakSelf setPageCountArrayValue:[weakSelf.unhandledDataSource count] AtIndex:UnhandledTableViewFlag];
            [weakSelf setPageCountArrayValue:[weakSelf.appliedDataSource count] AtIndex:MyAppliedTableViewFlag];
            [weakSelf.tableView reloadData];
        }
        else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[userListModel getInfo]];
            ALERT(error);
            [weakSelf.tableView reloadData];
        }
    }];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
}


-(NSInteger)getPageStartIndexWithSegmentIndex:(NSInteger)index
{
    NSInteger pageStartIndex;
    if (pageCountArray==nil) {
        return 0;
    }
    NSString *intString=[pageCountArray objectAtIndex:index];
    
    pageStartIndex=[intString integerValue];
    
    return pageStartIndex;
}


-(void)setPageCountArrayValue:(NSInteger)value  AtIndex:(NSInteger)index
{
    if (pageCountArray==nil || index<0 || index>=[pageCountArray count]) {
        return;
    }
    NSString *intString=[NSString stringWithFormat:@"%ld",(long)value];
    [pageCountArray replaceObjectAtIndex:index withObject:intString];
}


-(void)startLocationService:(void(^)(void))block
{
    AJLocationManager *ajLocationManager=[AJLocationManager shareLocation];
    [ajLocationManager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [self hideHud];
        rightNowGPS=[[geoModel alloc]initWith:locationCorrrdinate.longitude lat:locationCorrrdinate.latitude];
//        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
//        [mySettingData setObject:rightNowGPS forKey:CURRENTLOCATOIN];
//        [mySettingData synchronize];
        block();
        //请求数据
    } error:^(NSError *error) {
        [self hideHud];
        ALERT(error.description);
    }];
}


-(void)createCancelFavoriteReq:(NSString*)user_id
{
    //  +(void)deleteTheJob:(NSString *)enterprise_id job_id:(NSString *)job_id withBlock:(operationReturnBlock)oprationReturnBlock;
    if (user_id==nil || [selectedCellRow row]<0 || [selectedCellRow row]>=[self.faviriteDataSource count]) {
        //处理删除请求
        ALERT(@"错误,请重试");
        return ;
        
    }
    //处理删除请求
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除此条职位？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    alert.tag=60001;
    //    [alert show];
    selectedUserId=user_id;
    [self doCancelFavoriteReq];
}

-(void)deleteCellAtIndexPath:(NSIndexPath*)path
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
}


-(void)doCancelFavoriteReq
{
    if (selectedUserId==nil) {
        ALERT(@"UserId不存在,请重试");
        return;
    }
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
    [self showHudInView:self.tableView hint:@"取消中"];
    [netAPI cancelFocusUser:com_id user_id:selectedUserId withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[
                                                       NSNumber numberWithInt:BASE_SUCCESS ]]) {
            if ([selectedCellRow row]>=0 || [selectedCellRow row]<[self.faviriteDataSource count]) {
                [self.faviriteDataSource removeObjectAtIndex:[selectedCellRow row]];
                NSIndexPath *path=selectedCellRow;
                [self deleteCellAtIndexPath:path];
                [self.tableView reloadData];
                ALERT(@"删除成功");
            }
            else
            {
                ALERT(@"列表错误，请重试");
            }
        }else
        {
            NSString *errorDescription=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
            ALERT(errorDescription);
        }
    }];
}
@end
