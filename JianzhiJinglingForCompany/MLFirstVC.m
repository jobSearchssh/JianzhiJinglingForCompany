//
//  MLFirstVC.m
//  jobSearch
//
//  Created by RAY on 15/1/16.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFirstVC.h"
#import "MLCell1.h"
#import "NiftySearchView.h"
#import "MLMapView.h"
#import "MLFilterVC.h"
#import "jobDetailVC.h"
#import "MLMessageVC.h"
#import "MLMatchVC.h"
#import "MLLoginBusiness.h"

@interface MLFirstVC ()<NiftySearchViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UITabBarDelegate>
{
    NSInteger cellNum;
    NiftySearchView *searchView;
    MLMapView *mapView;
    
    BOOL mapDisplaying;
}

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation MLFirstVC
@synthesize tableView=_tableView;


static  MLFirstVC *thisVC=nil;

+ (MLFirstVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLFirstVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    searchView = [[NiftySearchView alloc] initWithFrame:CGRectMake(0, -76, [[UIScreen mainScreen] bounds].size.width, 76)];
    searchView.delegate = self;
    [_tableView addSubview:searchView];
    searchView.alpha=0.0f;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.title=@"附近的工作";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    [self tableViewInit];
    
    mapDisplaying=NO;
    
    [self initTabbar];
    
    MLLoginBusiness *log=[[MLLoginBusiness alloc]init];

}

- (void)viewWillLayoutSubviews{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    [self.tabbar setSelectedImageTintColor: [UIColor whiteColor]];
    
}

- (void)initTabbar{
    [[self.tabbar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
    
    
    [[self.tabbar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"catagory"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"catagory"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:1] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:2] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:3] setFinishedSelectedImage:[[UIImage imageNamed:@"target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:3] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:4] setFinishedSelectedImage:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:4] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    self.tabbar.delegate=self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag==0) {
        [self showMap];
    }else if (item.tag==1){
        [self sort];
    }else if (item.tag==2){
        [self showMessage];
    }else if (item.tag==3){
        [self filter];
    }else if (item.tag==4){
        [self showMatchInfo];
    }
}

- (void)showMatchInfo{
    MLMatchVC *matchVC=[[MLMatchVC alloc]init];
    matchVC.title=@"精灵匹配";
    [self.navigationController pushViewController:matchVC animated:YES];
}

- (void)showMap{
    if (!mapDisplaying) {
        if (!mapView) {
            mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-113)];
            mapView.alpha=0.0f;
            [self.view addSubview:mapView];
        }
        mapDisplaying=YES;
        [UIView animateWithDuration:0.4 animations:^{
            mapView.alpha=1.0f;
        }];
    }else {
        [UIView animateWithDuration:0.4 animations:^{
            mapView.alpha=0.0f;
        }];
        mapDisplaying=NO;
    }
}
- (void)showMessage{
    MLMessageVC *messageVC=[[MLMessageVC alloc]init];
    messageVC.title=@"消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)filter{
    MLFilterVC *filterVC=[[MLFilterVC alloc]init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

//*********************ActionSheet********************//
- (void)sort{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择排序类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"智能排序", @"距离最近", @"最新发布",nil];

    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
        
    }else if(buttonIndex == 2) {
        
    }else if(buttonIndex == 3) {
        
    }
    
}

//*********************searchView********************//
- (void)search{
    [UIView animateWithDuration:0.4 animations:^{
        searchView.alpha=1.0f;
    }];
    if ([searchView.startTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        searchView.startTextField.textColor = [UIColor blueColor];
    } else {
        searchView.startTextField.textColor = [UIColor blackColor];
    }
    if ([searchView.finishTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        searchView.finishTextField.textColor = [UIColor blueColor];
    } else {
        searchView.finishTextField.textColor = [UIColor blackColor];
    }
    
    CGRect searchBarFrame = searchView.frame;
    searchBarFrame.origin.y = 0;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion) {
                         [searchView.startTextField becomeFirstResponder];
                     }];
}

#pragma mark -
#pragma mark NiftySearchView Delegate Methods

- (void)startBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"startBookmarkButtonClicked");
}
- (void)finishBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"finishBookmarkButtonClicked");
}

- (void)niftySearchViewResigend
{
    NSLog(@"resignSearchView");
    [self hideSearchBar:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        searchView.alpha=0.0f;
    }];
}

- (void)routeButtonClicked:(UITextField *)startTextField finishTextField:(UITextField *)finishTextField
{
    NSLog(@"routeButtonClicked");
}

- (IBAction)hideSearchBar:(id)sender
{
    [searchView.startTextField resignFirstResponder];
    [searchView.finishTextField resignFirstResponder];
    CGRect searchBarFrame = searchView.frame;
    searchBarFrame.origin.y = -76;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion){
                         
                     }];
}

//*********************tableView********************//
- (void)tableViewInit{
    cellNum=10;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell1";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell1" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
//    [cell.portraitView.layer setCornerRadius:CGRectGetHeight(cell.portraitView.bounds)/2];
//    [cell.portraitView.layer setMasksToBounds:YES];
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
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
    
    jobDetailVC *detailVC=[[jobDetailVC alloc]init];
    detailVC.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    backItem.tintColor=[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:50.0/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
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
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
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
