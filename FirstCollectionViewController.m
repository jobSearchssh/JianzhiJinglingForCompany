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
@interface FirstCollectionViewController ()
{
    
    NSArray *_datasource;
    
}
@property (nonatomic,strong)UIBarButtonItem *searchBarItem;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"求职者";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    self.navigationItem.title=@"附近的人";
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes
    self.collectionView.backgroundColor=[UIColor darkGrayColor];
    // Register cell classes
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.allowsMultipleSelection=YES;
    self.collectionView.userInteractionEnabled=YES;
    // Do any additional setup after loading the view.
    UIButton *searchButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setImage:[UIImage imageNamed:@"search1"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchBarAction) forControlEvents:UIControlEventTouchUpInside];
    self.searchBarItem=[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem=self.searchBarItem;
    
//    [tapGestureRecognizer setCancelsTouchesInView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//search功能入口函数
-(void)searchBarAction
{
//    ALERT(@"功能还在完善中，谢谢。。。！");

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    //    cell.ContentImage.image=[UIImage imageNamed:@"img1"];
    //    [cell sizeToFit];
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
    person.hidesBottomBarWhenPushed=YES;
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


@end
