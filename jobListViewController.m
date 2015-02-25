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
    NSArray *_dataSource;
    NSInteger pageSize;
    NSMutableArray *_selectedJobArray;
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
            _dataSource=[jobListModel getJobArray];
            cellNum+=[_dataSource count];
            [weakSelf.tableView reloadData];
        }else
        {
            ALERT(@"数据加载失败，请重试");
        }
    }];
}


- (void)viewWillLayoutSubviews{
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendAction)];
    
    
}

-(void)viewDidLayoutSubviews
{
    [self.tableView footerEndRefreshing];
}


-(void)sendAction
{
    if ([_selectedJobArray count]>0) {
        //
        //        dispatch_group_t group=dispatch_group_create();
        //        //20s
        //        dispatch_time_t timeout=dispatch_time(DISPATCH_TIME_NOW, 20000000000);
        //        ALERT(@"邀请已发送");
        __block int progress=0;
        NSUInteger total=[_selectedJobArray count];
        hub=[[MBProgressHUD alloc]init];
        hub.labelText=[NSString stringWithFormat:@"发送邀请中...%d/%lu",progress,(unsigned long)total];
        [hub show:YES];
        NSString *com_id=[[NSUserDefaults standardUserDefaults]objectForKey:CURRENTUSERID];
        for (jobModel *job in _selectedJobArray) {
            [netAPI inviteUserWithEnterpriseId:com_id userId:self.user_id jobId:[job getjobID] withBlock:^(oprationResultModel *oprationModel) {
                if ([[oprationModel getStatus]intValue]==BASE_SUCCESS) {
                    progress+=1;
                    hub.labelText=[NSString stringWithFormat:@"发送邀请中...%d/%lu",progress,(unsigned long)total];
                }
                else {
                    //                        [hub show:NO];
                    NSString *string=[NSString stringWithFormat:@"%@",[oprationModel getInfo]];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showError:string toView:self.view];
                    //                    ALERT(string);
                }
                if (progress==total) {
                    [hub show:NO];
                    [MBProgressHUD showSuccess:@"所有邀请已发送" toView:self.view];
                }
                else
                {   [hub show:NO];
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%d个邀请已发送",progress] toView:self.view];
                }
            }];
            
        }
    }
    //        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //            if (progress==total) {
    //                [MBProgressHUD showSuccess:@"所有邀请已发送" toView:self.view];
    //            }
    //            else
    //            {
    //               [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%d个邀请已发送",progress] toView:self.view];
    //            }
    //
    //        });
    //        dispatch_group_wait(group, timeout);
    //        dispatch_release(group);
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
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"jobListTableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"jobListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    jobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    CGPoint nowlocation=CGPointFromString([[NSUserDefaults standardUserDefaults]objectForKey:CURRENTLOCATOIN]);
    if (_dataSource!=nil) {
        jobModel *job=[_dataSource objectAtIndex:indexPath.row];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%f",[jobModel getDistance:@[[NSNumber numberWithDouble:nowlocation.x],[NSNumber numberWithDouble:nowlocation.y]]]] ;
        cell.addressLabel.text=[NSString stringWithFormat:@"%@",[job getjobWorkAddressDetail]];
        cell.jobTitleLabel.text=[NSString stringWithFormat:@"%@",[job getjobTitle]];
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
    jobListTableViewCell *cell=(jobListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    // Configure the view for the selected state
    if (_selectedJobArray==nil)
    {
        _selectedJobArray=[NSMutableArray array];
    }
    if(cell.selectedFlag==CELLSELECTED)
    {
        cell.checkIconView.image=[UIImage imageNamed:@"check_out"];
        cell.selectedFlag=CELLUNSELECTED;
        [_selectedJobArray removeObject:[_dataSource objectAtIndex:indexPath.row]];
    }
    else if (cell.selectedFlag==CELLUNSELECTED) {
        cell.checkIconView.image=[UIImage imageNamed:@"check"];
        cell.selectedFlag=CELLSELECTED;
        [_selectedJobArray addObject:[_dataSource objectAtIndex:indexPath.row]];
    }
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
