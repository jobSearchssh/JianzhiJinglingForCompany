//
//  jobListViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "jobListViewController.h"
#import "jobListTableViewCell.h"
#import "netAPI.h"
#import "MJRefresh.h"
#import "UIViewController+HUD.h"

#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@interface jobListViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger cellNum;
    NSMutableArray *_dataSource;
    NSInteger pageSize;
    NSMutableDictionary *_selectedJobArray;
    MBProgressHUD *hub;
}
@end

@implementation jobListViewController
//static jobListViewController*  thisVC;
//+(jobListViewController*)shareSingletonInstance
//{
//    if (thisVC==nil) {
//        thisVC=[[jobListTableViewCell alloc]init];
//    }
//    return thisVC;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self tableViewInit];
}
-(void)upDateDataFromNet
{
    NSUserDefaults *mySettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mySettings objectForKey:CURRENTUSERID];
    [self showHudInView:self.tableView hint:@"加载中"];
    jobListViewController *__weak weakSelf=self;
    [netAPI queryEnterpriseJobs:com_id start:cellNum length:pageSize withBlock:^(jobListModel *jobListModel) {
        [weakSelf hideHud];
        [weakSelf.tableView footerEndRefreshing];
        if ([[jobListModel getStatus]intValue]==BASE_SUCCESS) {
            if([[jobListModel getCount]intValue]==0)
            {
                ALERT(@"没有职位，请先返回发布一个职位");
                return ;
            }
            if (_dataSource==nil) {
                _dataSource=[NSMutableArray array];
            }
            [_dataSource addObjectsFromArray:[jobListModel getJobArray]];
            cellNum+=[_dataSource count];
            [weakSelf.tableView reloadData];
        }else
        {
            ALERT([jobListModel getInfo]);
        }
    }];
}


- (void)viewWillLayoutSubviews{
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendAction)];
    
    
}

-(void)viewDidLayoutSubviews
{
    [self.tableView footerEndRefreshing];
}


-(void)sendAction
{
    if ([[_selectedJobArray allKeys] count]>0) {
        
        
        
        [self showHudInView:self.view hint:@"邀请发送中..."];
        NSString *jobID=@"";
        for (NSIndexPath *index in _selectedJobArray)
        {
            jobModel *job=[_selectedJobArray objectForKey:index];
            jobID=[jobID stringByAppendingFormat:@"%@,",[job getjobID] ];
        }
        jobID=[jobID substringToIndex:[jobID length]];
        NSString *com_id=[[NSUserDefaults standardUserDefaults]objectForKey:CURRENTUSERID];
        [netAPI MultiInviteUserWithEnterpriseId:com_id userId:self.user_id jobId:jobID withBlock:^(oprationResultModel *oprationModel) {
            
            [self hideHud];
            if ([[oprationModel getStatus]intValue]==BASE_SUCCESS)
            {
                [MBProgressHUD showSuccess:@"所有邀请已发出" toView:self.view];
            }else
            {
                NSString *errorstring=[NSString stringWithFormat:@"发送失败，原因:%@",[oprationModel getInfo]];
                ALERT(errorstring);
                
            }
            
            
        }];
        //
    }
    else
    {
        ALERT(@"请先选择职位");
        return;
    }
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
#pragma --mark  TableView Delegate
//*********************tableView********************//
- (void)tableViewInit{
    cellNum=1;
    pageSize=10;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.scrollEnabled=YES;
    [self upDateDataFromNet];
}

-(void)footerRefreshing
{
    [self upDateDataFromNet];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"jobListTableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"jobListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    jobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    //清理选择数据 为未选中
    cell.selectedFlag=CELLUNSELECTED;
    cell.checkIconView.image=[UIImage imageNamed:@"check_out"];
    cell.jobImageView.image=[UIImage imageNamed:@"placeholder"];
    //设置选择cell
    if ([_selectedJobArray count]>0)
    {
        for (NSIndexPath *index in [_selectedJobArray allKeys]) {
            if(indexPath==index)
            {
                cell.selectedFlag=CELLSELECTED;
                cell.checkIconView.image=[UIImage imageNamed:@"check"];
                
            }
        }
        
    }
    
    
    CGPoint nowlocation=CGPointFromString([[NSUserDefaults standardUserDefaults]objectForKey:CURRENTLOCATOIN]);
    if (_dataSource!=nil) {
        jobModel *job=[_dataSource objectAtIndex:indexPath.row];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",[jobModel getDistance:@[[NSNumber numberWithDouble:nowlocation.x],[NSNumber numberWithDouble:nowlocation.y]]]] ;
        cell.addressLabel.text=[NSString stringWithFormat:@"%@",[job getjobWorkAddressDetail]];
        cell.jobTitleLabel.text=[NSString stringWithFormat:@"%@",[job getjobTitle]];
        cell.recruitNumLabel.text=[NSString stringWithFormat:@"招募:%d/%d",[[job getjobHasAccepted]intValue],[[job getjobRecruitNum]intValue]];
        NSString *imageUrl;
        [job getjobEnterpriseImageURL];
        if ([job getjobEnterpriseImageURL]) {
            NSString *url1=[job getjobEnterpriseImageURL];
            if ([url1 length]>4) {
                if ([[url1 substringToIndex:4] isEqualToString:@"http"])
                    imageUrl=url1;
            }
        }
        else if([job getjobEnterpriseLogoURL])
        {
            NSString *url1=[job getjobEnterpriseImageURL];
            if ([url1 length]>4) {
                if ([[url1 substringToIndex:4] isEqualToString:@"http"])
                    imageUrl=url1;
            }
        }
        
        if ([imageUrl length]>4) {
            cell.jobImageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.jobImageView.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.jobImageView];
            cell.jobImageView.imageURL=[NSURL URLWithString:imageUrl];
        }else{
            cell.jobImageView.image=[UIImage imageNamed:@"placeholder"];
        }
    }
    //    [cell.portraitView.layer setCornerRadius:CGRectGetHeight(cell.portraitView.bounds)/2];
    //    [cell.portraitView.layer setMasksToBounds:YES];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];;
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
    NSLog(@"%@",indexPath);
    jobListTableViewCell *cell=(jobListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    // Configure the view for the selected state
    if (_selectedJobArray==nil)
    {
        _selectedJobArray=[NSMutableDictionary dictionary];
    }
    if(cell.selectedFlag==CELLSELECTED)
    {
        //点击取消选择
        cell.checkIconView.image=[UIImage imageNamed:@"check_out"];
        cell.selectedFlag=CELLUNSELECTED;
        [_selectedJobArray removeObjectForKey:indexPath];
    }
    else if (cell.selectedFlag==CELLUNSELECTED) {
        //点击选择
        cell.checkIconView.image=[UIImage imageNamed:@"check"];
        cell.selectedFlag=CELLSELECTED;
        [_selectedJobArray setObject:[_dataSource objectAtIndex:indexPath.row] forKey:indexPath];
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:1.0f];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}



//*********************swipeableTableViewCell********************//
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
