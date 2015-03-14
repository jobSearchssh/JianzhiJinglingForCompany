//
//  MyInvitedViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/3/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "MyInvitedViewController.h"
#import "TableViewCell.h"
#import "netAPI.h"
#import "MJRefresh.h"
#import "MLResumePreviewVC.h"
#import "NSDate+Category.h"
#import "UIViewController+HUD.h"
#import "JSBadgeView.h"
#import "UIViewController+LoginManager.h"
#import <MAMapKit/MAMapKit.h>
#import "geoModel.h"
#import "BadgeManager.h"
#import "iniviteModel.h"
#import "jobModel.h"
#import "PageSplitingManager.h"
@interface MyInvitedViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    NSInteger pageSizeNum;
    NSInteger cellNum;
    
    NSString *selectedUserInvitedId;
    NSIndexPath *selectedCellRow;
    BOOL touchRefresh;
    
}
@property (strong,nonatomic)NSMutableArray *datasourceArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)PageSplitingManager *pageManager;
@end

@implementation MyInvitedViewController

static MyInvitedViewController *thisVC;
+ (MyInvitedViewController *)shareSingletonInstance
{
    if (thisVC == nil) {
        thisVC = [[MyInvitedViewController alloc]init];
    }
    return thisVC;
}
-(PageSplitingManager*)pageManager
{
    if (_pageManager == nil) {
        _pageManager=[[PageSplitingManager alloc]initWithPageSize:10];
    }
    return _pageManager;
}

-(void)autoLoadData
{
    [self headerRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self tableViewInit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLoadData) name:@"autoLoadNearData" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)tableViewInit{
    pageSizeNum=10;
    cellNum=0;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.navigationItem.title=Tit_Invitation;
    self.datasourceArray=[NSMutableArray array];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    //第一次加载
    [self footerRefreshing];
    touchRefresh=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideHud];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (void)headerRefreshing
{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    [self.pageManager resetPageSplitingManager];
    touchRefresh=YES;
    [self loadDatafromIndex:self.pageManager.firstStartIndex   Length:self.pageManager.pageSize];
}


- (void)footerRefreshing{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    if (cellNum!=0) {
        [self loadDatafromIndex:[self.pageManager getNextStartAt] Length:self.pageManager.pageSize];
    }
    else {
        touchRefresh=YES;
        [self loadDatafromIndex:self.pageManager.firstStartIndex    Length:self.pageManager.pageSize];
    }
}


-(void)loadDatafromIndex:(int)start Length:(int)length
{
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
    }
    else {
        MyInvitedViewController *__weak weakSelf=self;
        [netAPI queryInivitesList:com_id start:start length:length withBlock:^(inivitesListModel *inivitesListModel) {
            [weakSelf hideHud];
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            if ([[inivitesListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
                if (touchRefresh) {
                    [weakSelf.datasourceArray removeAllObjects];
                    touchRefresh=NO;
                }
                [[BadgeManager shareSingletonInstance]refreshCount];
                [weakSelf.pageManager pageLoadCompleted];
                [weakSelf.datasourceArray addObjectsFromArray:[inivitesListModel getinivitesArray]];
                cellNum=[weakSelf.datasourceArray count];
                [weakSelf.tableView reloadData];
            }
            else
            {
                NSString *error=[NSString stringWithFormat:@"%@",[inivitesListModel getInfo]];
                ALERT(error);
                [weakSelf.tableView reloadData];
            }
        }];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:20];
    }
}





#pragma --mark TableView Delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    cell.badgeView.badgeText=nil;
    
    //重新设置
    iniviteModel *invitation=[self.datasourceArray
                              objectAtIndex:indexPath.row];
    userModel *user=[invitation getuserModel];
    jobModel *job=[invitation getjobModel];
    cell.usrNameLabel.text=[NSString stringWithFormat:@"%@ 邀请职位:%@", [user getuserName], [job getjobTitle]];
    
    const NSDictionary *TYPESELECTEDDICT=@{@"模特/礼仪":@"0", @"促销/导购":@"1", @"销售":@"2" ,@"传单派发":@"3" ,@"安保":@"4" ,@"钟点工":@"5", @"法律事务":@"6", @"服务员":@"7" ,@"婚庆":@"8", @"配送/快递":@"9", @"化妆":@"10", @"护工/保姆":@"11", @"演出":@"12", @"问卷调查":@"13", @"志愿者":@"14" ,@"网络营销":@"15" ,@"导游":@"16", @"游戏代练":@"17", @"家教":@"18", @"软件/网站开发":@"19", @"会计":@"20", @"平面设计/制作":@"21", @"翻译":@"22", @"装修":@"23", @"影视制作":@"24", @"搬家":@"25", @"其他":@"26"};
    
    //设置工作类型
    NSMutableDictionary *typeForReanlysis=[NSMutableDictionary dictionary];
    NSArray *keyword=[TYPESELECTEDDICT allKeys];
    for (NSString *value in keyword) {
        [typeForReanlysis setObject:value forKey:[TYPESELECTEDDICT objectForKey:value]];
    }
    NSString *usrintention=Text_JobTarget;
    for (int i=0; i<[[user getuserHopeJobType] count]; i++) {
        NSString *aaa=[NSString stringWithFormat:@"%@",[[user getuserHopeJobType]objectAtIndex:i]];
        usrintention = [usrintention stringByAppendingString:[NSString stringWithFormat:@" %@",[typeForReanlysis objectForKey:aaa]]];
    }
    
    cell.usrJobReq.text=usrintention;
    
    NSString *handlerString=Text_HandleResults;
    if ([[invitation getinviteStatus]intValue]==0) {
        handlerString=[handlerString stringByAppendingString:Text_UnHandle];
    }else if ([[invitation getinviteStatus]intValue]==1)
    {
        handlerString=[handlerString stringByAppendingString:Text_Refuse];
        
    }else if ([[invitation getinviteStatus]intValue]==2)
    {
        
        handlerString=[handlerString stringByAppendingString:Text_Accept];
    }
    
    cell.usrBreifIntro.text=handlerString;

    cell.timeStamp.text=[[user getUpdateAt]timeIntervalDescription];
    
    NSString *locationString= [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLOCATOIN];
    CGPoint point=CGPointFromString(locationString);
    if (locationString!=nil) {
        geoModel *_rightNowGeoPoint=[[geoModel alloc]initWith:point.x lat:point.y];
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_rightNowGeoPoint getLat],[_rightNowGeoPoint getLon]));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[user getuserLocationGeo] getLat],[[user getuserLocationGeo] getLon]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        float kmDistance=distance/1000;
        cell.distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",kmDistance];
    }
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
            //            cell.usrImage.contentMode = UIViewContentModeScaleAspectFill;
            //            cell.usrImage.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.usrImage];
            cell.usrImage.imageURL=[NSURL URLWithString:imageUrl];
        }else{
            cell.usrImage.image=[UIImage imageNamed:@"placeholder"];
        }
    }
    cell.userId=[invitation getinvite_id];
    cell.index=indexPath;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    
    //标记已读未读
    NSNumber *isRead=[NSNumber numberWithInt:[[invitation getenterpriseInviteIsRead] intValue]];
    if ([isRead intValue]==0) {
        cell.badgeView.badgeText=@"1";
    }
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"trash"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] title:Btn_UnInvitation];
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasourceArray count];
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
    TableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.badgeView.badgeText!=nil) {
        //减少badge
        [[BadgeManager shareSingletonInstance]minusMessageCount];
        
        [netAPI setRecordAlreadyRead:[[NSUserDefaults standardUserDefaults]objectForKey:CURRENTUSERID] applyOrInviteId:cell.userId type:@"0" withBlock:^(oprationResultModel *oprationModel) {
            [self headerRefreshing];
            NSLog(@"%@",[oprationModel getInfo]);
            
        }];
        cell.badgeView.badgeText=nil;
    }
    
    
    MLResumePreviewVC *person=[[MLResumePreviewVC alloc]initWithNibName:@"MLResumePreviewVC" bundle:nil];
    
    iniviteModel *invitation=[self.datasourceArray objectAtIndex:indexPath.row];
    userModel *user=[invitation getuserModel];
    person.edgesForExtendedLayout=UIRectEdgeNone;
    person.jobUserId=[user getjob_user_id];
    person.thisUser=user;
    person.hideRightBarButton=YES;
    person.hidesBottomBarWhenPushed=YES;
    person.stateFlag=UnhanldedState;
    person.hideAcceptBtn=YES;
    
    if ([[invitation getinviteStatus]intValue]==2) person.isShowPhone=YES;
    
    [self.navigationController pushViewController:person animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:1.0];
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
            selectedUserInvitedId=cell1.userId;
            selectedCellRow=cell1.index;
            [self createCancelFavoriteReq:selectedUserInvitedId];
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
            return YES;
            break;
        default:
            break;
    }
    return YES;
}



-(void)createCancelFavoriteReq:(NSString*)user_id
{
    //  +(void)deleteTheJob:(NSString *)enterprise_id job_id:(NSString *)job_id withBlock:(operationReturnBlock)oprationReturnBlock;
    if (user_id==nil || [selectedCellRow row]<0 || [selectedCellRow row]>=[self.datasourceArray count]) {
        //处理删除请求
        ALERT(Text_Error);
        return ;
        
    }
    
    selectedUserInvitedId=user_id;
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
    if (selectedUserInvitedId==nil) {
        ALERT(Text_Error);
        return;
    }
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
    [self showHudInView:self.tableView hint:Text_Cancelling];
    [netAPI cancelInvitedUser:com_id invite_id:selectedUserInvitedId withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[
                                                       NSNumber numberWithInt:BASE_SUCCESS ]]) {
            if ([selectedCellRow row]>=0 || [selectedCellRow row]<[self.datasourceArray count]) {
                [self.datasourceArray removeObjectAtIndex:[selectedCellRow row]];
                NSIndexPath *path=selectedCellRow;
                [self deleteCellAtIndexPath:path];
                [self.tableView reloadData];
                ALERT(Text_DeleteSuccess);
            }
            else
            {
                ALERT(Text_LoadAfterDeleteError);
            }
        }else
        {
            NSString *errorDescription=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
            ALERT(errorDescription);
        }
    }];
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

@end
