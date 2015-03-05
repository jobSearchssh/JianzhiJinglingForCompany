//
//  JobPublishedListViewController.m
//  tableViewTest
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "JobPublishedListViewController.h"
#import "TableViewCell2.h"
#import "netAPI.h"
#import "UIViewController+HUD.h"
#import "jobModel.h"
#import "NSDate+Category.h"
#import "SRRefreshView.h"
#import "MJRefresh.h"
#import "UIViewController+LoginManager.h"
#import "jobPublicationViewController.h"
#import "PageSplitingManager.h"
#import "MLNaviViewController.h"
#import "MLLoginVC.h"
@interface JobPublishedListViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,SRRefreshDelegate,UIAlertViewDelegate>
{
    NSInteger cellNum;
    NSInteger pageSize;
    NSString *selectedJobId;
    NSInteger selectedCellRow;
}

@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (strong,nonatomic)NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)PageSplitingManager *pageManager;
@end

@implementation JobPublishedListViewController
@synthesize tableView=_tableView;


-(PageSplitingManager*)pageManager
{
    if(_pageManager==nil)
    {
        _pageManager=[[PageSplitingManager alloc]initWithPageSize:10];
    }
    return _pageManager;
}

#pragma --mark  getter
- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}




- (void)viewDidLoad {
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(publishNewJob)];
//    [self.navigationItem.rightBarButtonItem setTitle:@"创建新职位"];
    
    self.navigationItem.title=@"我的发布";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self tableViewInit];
}

- (void)tableViewInit{
    cellNum=10;
    pageSize=10;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
//    [_tableView addSubview:self.slimeView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    //    self.tableView.hidden=YES;
    [self downloadDataListStartAt:self.pageManager.firstStartIndex Length:self.pageManager.pageSize];
}

-(void)headerRefreshing
{
    [self refreshDataSource];

}

-(void)footerRefreshing
{
    
    [self downloadDataListStartAt:[self.pageManager getNextStartAt ] Length:self.pageManager.pageSize];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideHud];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];

}

-(void)downloadDataListStartAt:(int)start Length:(int)length
{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:@"currentUserObjectId"];
    NSLog(@"com_id:%@",com_id);
    [self showHudInView:self.tableView hint:@"加载中.."];
    [netAPI queryEnterpriseJobs:com_id start:start length:length withBlock:^(jobListModel *jobListModel) {
        [self hideHud];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if ([jobListModel getStatus]) {
            if (self.dataSourceArray==nil) {
                self.dataSourceArray=[NSMutableArray array];
            }
            self.dataSourceArray=[jobListModel getJobArray];
            [self.pageManager pageLoadCompleted];
            cellNum=[self.dataSourceArray count];
            [self hideHud];
            [self.tableView reloadData];
        }
        else
        {
            [self hideHud];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[jobListModel getInfo] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:@"取消",nil];
            [alert show];
        }
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"TableViewCell2";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"TableViewCell2" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
     cell.jobImageView.image=[UIImage imageNamed:@"placeholder"];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
   
    cell.delegate = self;
    
    if (self.dataSourceArray!=nil) {
        if ( [[self.dataSourceArray objectAtIndex:indexPath.row]isKindOfClass:[jobModel class]])
        {
            jobModel *job=[self.dataSourceArray objectAtIndex:indexPath.row];
            cell.row=indexPath.row;
            cell.jobTitleLabel.text=[job getjobTitle];
            cell.jobAddressDetailLabel.text=[job getjobWorkAddressDetail];
            cell.jobUpdateTimeLabel.text=[[job getcreated_at] timeIntervalDescription];
            cell.Job_id=[job  getjobID];
            
            NSString *imageurl=[NSString stringWithFormat:@"%@",[job getjobEnterpriseImageURL]];
            if ([imageurl length]>4) {
                if ([[imageurl substringToIndex:4]isEqualToString:@"http"]) {
                    
                    cell.jobImageView.contentMode = UIViewContentModeScaleAspectFill;
                    cell.jobImageView.clipsToBounds = YES;
                    [[AsyncImageLoader sharedLoader]cancelLoadingImagesForTarget:cell.jobImageView];
                    cell.jobImageView.imageURL=[NSURL URLWithString:imageurl];
                }
            }
            else
            {
                NSString *imageurl1=[NSString stringWithFormat:@"%@",[job getjobEnterpriseLogoURL]];
                if ([imageurl1 length]>4&&[[imageurl1 substringToIndex:4]isEqualToString:@"http"]) {
                    
                    cell.jobImageView.contentMode = UIViewContentModeScaleAspectFill;
                    cell.jobImageView.clipsToBounds = YES;
                    [[AsyncImageLoader sharedLoader]cancelLoadingImagesForTarget:cell.jobImageView];
                    cell.jobImageView.imageURL=[NSURL URLWithString:imageurl1];
                }
            }
            
            
        }
    }
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"edit1"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"trash"]];
    
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceArray==nil) {
        return 0;
    }else
    {
        return [self.dataSourceArray count];
    }
    
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
    
    jobPublicationViewController *jobDetailVC=[[jobPublicationViewController alloc]init];
    jobDetailVC.viewStatus=PublishedJob;
    jobDetailVC.editButtonEnable=NO;
    jobDetailVC.hidesBottomBarWhenPushed=YES;
    jobDetailVC.isHideBottomBtn=YES;
    jobDetailVC.publishedJob=[self.dataSourceArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:jobDetailVC animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:2.0f];
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
        {
            NSLog(@"left button 0 was pressed");
            break;
        }
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
            NSLog(@"left button 0 was pressed");
            
            TableViewCell2 *thisCell=cell;
            NSLog(@"left button 0 was pressed,thisCell.Job_id：%@",thisCell.Job_id);
            [self createDeleteJobReq:thisCell.Job_id];
            
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
            return YES;
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

-(void)deleteCellAtIndexPath:(NSIndexPath*)path
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
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


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}



-(void)refreshDataSource
{ if (![UIViewController isLogin]) {
    [self notLoginHandler];
    return;
}
    [self.pageManager resetPageSplitingManager];
    [self downloadDataListStartAt:[self.pageManager getNextStartAt] Length:self.pageManager.pageSize];
}



-(void)publishNewJob
{

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 60001:
            if(buttonIndex==1)
            {
                //提交网络请求
                [self doDeleteReq];
                
            }
            break;
        case 323432:
        {
            if (buttonIndex==1) {
                MLNaviViewController *navi=[[MLNaviViewController alloc]initWithRootViewController:[MLLoginVC sharedInstance]];
                [self presentViewController:navi animated:YES completion:^{
                    
                }];
            }
            break;
        }
        default:
            break;
    }
}



-(void)createDeleteJobReq:(NSString*)job_id
{
    //  +(void)deleteTheJob:(NSString *)enterprise_id job_id:(NSString *)job_id withBlock:(operationReturnBlock)oprationReturnBlock;
    if (job_id==nil || selectedCellRow<0 || selectedCellRow>=[self.dataSourceArray count]) {
        //处理删除请求
        ALERT(@"错误,请重试");
        return ;
        
    }
    //处理删除请求
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除此条职位？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=60001;
    [alert show];
    selectedJobId=job_id;
    
    
}


-(void)doDeleteReq
{
    if (selectedJobId==nil) {
        ALERT(@"JobId不存在,请重试");
        return;
    }
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
    [self showHudInView:self.tableView hint:@"删除中"];
    [netAPI deleteTheJob:com_id job_id:selectedJobId withBlock:^(oprationResultModel *oprationModel) {
        [self hideHud];
        if ([[oprationModel getStatus]isEqualToNumber:[
            NSNumber numberWithInt:BASE_SUCCESS ]]) {
            if (selectedCellRow>=0 || selectedCellRow<[self.dataSourceArray count]) {
                [self.dataSourceArray removeObjectAtIndex:selectedCellRow];
                NSIndexPath *index=[NSIndexPath indexPathForRow:selectedCellRow inSection:0];
                [self deleteCellAtIndexPath:index];
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
