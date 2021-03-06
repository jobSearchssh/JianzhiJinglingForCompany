//
//  FirstCollectionViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/26/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "PersonProfileViewController.h"
#import "MLResumePreviewVC.h"
#import "AJLocationManager.h"
#import "netAPI.h"
#import "UIViewController+HUD.h"
#import <MAMapKit/MAMapKit.h>
#import "geoModel.h"
#import "MJRefresh.h"
#import "UIViewController+RESideMenu.h"
#import "MLFilterVC.h"

#import "PageSplitingManager.h"
@interface FirstCollectionViewController ()<UIAlertViewDelegate,finishFilterDelegate>
{
    NSMutableArray *_datasource;
    NSInteger cellNum;
    NSInteger pageSize;
    geoModel *rightNowGPS;
    BOOL touchRefresh;
}
@property (nonatomic,strong)UIBarButtonItem *searchBarItem;
@property (nonatomic,strong)AJLocationManager *ajLocationManager;

@property (nonatomic)PageSplitingManager *pageManager;

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier = @"CustomCollectionCell";

static  FirstCollectionViewController *thisVC=nil;

+ (FirstCollectionViewController*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[FirstCollectionViewController alloc]init];
    }
    return thisVC;
}


-(PageSplitingManager*)pageManager
{
    if (_pageManager == nil) {
        _pageManager=[[PageSplitingManager alloc]initWithPageSize:20];
    }
    return _pageManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    touchRefresh=NO;
    self.title=@"求职者";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    self.navigationItem.title=@"附近的人";
    // Uncomment the following line to preserve selection between presentations

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLoadNearData) name:@"autoLoadNearData" object:nil];
    
    // Register cell classes

    self.collectionView.backgroundColor=[UIColor darkGrayColor];
    // Register cell classes
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.scrollEnabled=YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentSize=CGSizeMake(MainScreenWidth, MainScreenHeight*1.5);
    self.collectionView.allowsMultipleSelection=YES;
    self.collectionView.userInteractionEnabled=YES;
    // Do any additional setup after loading the view.
    UIButton *searchButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setImage:[UIImage imageNamed:@"search1"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchBarAction) forControlEvents:UIControlEventTouchUpInside];
    self.searchBarItem=[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem=self.searchBarItem;
    
    //addRefreshButton
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    cellNum=0;
    pageSize=20;
    //第一次请求地址
    [self startLocationService];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)autoLoadNearData
{
    if (cellNum!=0) return;
    [self headerRefresh];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideHud];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
}

//search功能入口函数
-(void)searchBarAction
{
    MLFilterVC *filterVC=[[MLFilterVC alloc]init];
    filterVC.hidesBottomBarWhenPushed=YES;
    filterVC.edgesForExtendedLayout=UIRectEdgeNone;
    filterVC.filterDelegate=self;
    [self.navigationController pushViewController:filterVC animated:YES];
}



#pragma --mark filterDelegate
-(void)finishFilter:(int)_distance Length:(int)length
{
    NSInteger distanceParameter=_distance;
    [netAPI queryNearestUsersWithDistance:@"null" start:1 length:length lon:[rightNowGPS getLon] lat:[rightNowGPS getLat] distance:distanceParameter withBlock:^(userListModel *userListModel) {
        [self hideHud];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            [_datasource removeAllObjects];
            NSLog(@"queryNearestUsersByDistance info = %@",[userListModel getInfo]);
            [_datasource removeAllObjects];
            [_datasource addObjectsFromArray:[userListModel getuserArray]];
             self.navigationItem.title=[NSString stringWithFormat: @"附近的人:%ldkm",(long)distanceParameter];
            
            [self.collectionView reloadData];
        }
        else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:Text_Note message:[userListModel getInfo] delegate:self cancelButtonTitle:Text_GetKnownText otherButtonTitles:Text_RetryText,nil];
            alertView.tag=30001;
            [alertView show];
        }
    }];
}



#pragma --mark  网络请求
//附近的人，变的逻辑 随时刷新
-(void)startLocationService
{
    self.ajLocationManager=[AJLocationManager shareLocation];
    [self showHudInView:self.view hint:Text_Locating];
    [self.ajLocationManager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [self hideHud];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        rightNowGPS=[[geoModel alloc]initWith:locationCorrrdinate.longitude lat:locationCorrrdinate.latitude];
        NSString *gpsString=[NSString stringWithFormat:@"{%f,%f}",[rightNowGPS getLon],[rightNowGPS getLat]];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:gpsString forKey:CURRENTLOCATOIN];
        [mySettingData synchronize];
        //请求数据
            [self prepareRequestParametersStartAt:self.pageManager.firstStartIndex Length:self.pageManager.pageSize];

            } error:^(NSError *error) {
        [self hideHud];
        ALERT(error.description);
        
    }];
}

-(void)prepareRequestParametersStartAt:(int)index Length:(int)size
{
    [self showHudInView:self.collectionView hint:Text_Loading];
    [self loadData:@"null" GeoModel:rightNowGPS StartAt:index Length:size];
}


-(void)loadData:(NSString*)com_id GeoModel:(geoModel*)geo StartAt:(int)index Length:(int)size
{
    if (_datasource==nil) {
        _datasource=[NSMutableArray array];
    }
    [netAPI queryNearestUsers:com_id start:index length:size lon:[geo getLon] lat:[geo getLat] withBlock:^(userListModel *userListModel) {
        self.navigationItem.title=@"附近的人";
        [self hideHud];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        if ([[userListModel getStatus] isEqualToNumber:[NSNumber numberWithInt:BASE_SUCCESS]]) {
            if (touchRefresh) {
                [_datasource removeAllObjects];
                touchRefresh=NO;
            }
            [self.pageManager pageLoadCompleted];
            NSLog(@"queryNearestUsers info = %@",[userListModel getInfo]);
            [_datasource addObjectsFromArray:[userListModel getuserArray]];
            cellNum=[_datasource count];
            [self.collectionView reloadData];
        }
        else{
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:[userListModel getInfo] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重试",nil];
            alertView.tag=30001;
            [alertView show];
        }
    }];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasource!=nil) {
        return [_datasource count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //resetCell image
    cell.ContentImage.image=[UIImage imageNamed:@"placeholder"];
    cell.distanceLabelWithoutUnit.text=@"";
    // Configure the cell
    if (_datasource!=nil) {
        userModel *user=[_datasource objectAtIndex:indexPath.row];
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([rightNowGPS getLat],[rightNowGPS getLon]));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[user getuserLocationGeo] getLat],[[user getuserLocationGeo] getLon]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        float kmDistance=distance/1000;
        cell.distanceLabelWithoutUnit.text=[NSString stringWithFormat:@"%.2fkm",kmDistance];

        
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
                cell.ContentImage.contentMode = UIViewContentModeScaleAspectFill;
                cell.ContentImage.clipsToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.ContentImage];
                cell.ContentImage.imageURL=[NSURL URLWithString:imageUrl];
            }else{
                cell.ContentImage.image=[UIImage imageNamed:@"placeholder"];
            }
        }
        cell.markIconImageView.image=nil;
        
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLResumePreviewVC *person=[[MLResumePreviewVC alloc]initWithNibName:@"MLResumePreviewVC" bundle:nil];
    userModel *user=[_datasource objectAtIndex:indexPath.row];
    person.jobUserId=[user getjob_user_id];
    person.thisUser=user;
    person.hidesBottomBarWhenPushed=YES;
    person.stateFlag=InviteState;
    [self.navigationController pushViewController:person animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(CollectionViewItemsWidth,CollectionViewItemsWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma --mark  UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 30001:
        {
            if (buttonIndex==1) {
                [self startLocationService];
            }
        }
            break;
        default:
            break;
    }
}


//上拉刷新
-(void)headerRefresh
{
    [self hideHud];
    [self.pageManager resetPageSplitingManager];
    [self startLocationService];
    touchRefresh=YES;
}

//下拉加载更多
-(void)footerRefresh
{
     [self hideHud];
    [self prepareRequestParametersStartAt:[self.pageManager getNextStartAt] Length:self.pageManager.pageSize];
}
@end
