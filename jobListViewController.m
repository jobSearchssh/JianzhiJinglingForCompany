//
//  jobListViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "jobListViewController.h"
#import "jobListTableViewCell.h"
@interface jobListViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
 NSInteger cellNum;
}
@end

@implementation jobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self tableViewInit];

}
- (void)viewWillLayoutSubviews{
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendAction)];

    
}


-(void)sendAction
{

    ALERT(@"邀请已发送");


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
    cellNum=10;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
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
    //    [cell.portraitView.layer setCornerRadius:CGRectGetHeight(cell.portraitView.bounds)/2];
    //    [cell.portraitView.layer setMasksToBounds:YES];
    return cell;
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

    jobListTableViewCell *cell=(jobListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    // Configure the view for the selected state
    
    if(cell.selectedFlag==CELLSELECTED)
    {
        cell.checkIconView.image=[UIImage imageNamed:@"check_out"];
        cell.selectedFlag=CELLUNSELECTED;
    }
    else if (cell.selectedFlag==CELLUNSELECTED) {
        cell.checkIconView.image=[UIImage imageNamed:@"check"];
        cell.selectedFlag=CELLSELECTED;
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
