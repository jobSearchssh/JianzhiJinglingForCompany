//
//  ApplyDetailVCViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/27/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "ApplyDetailVCViewController.h"
#import "coverFlowView.h"
#import "freeselectViewCell.h"
@interface ApplyDetailVCViewController ()
{
    NSArray *_userImageArray;
    
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;

}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollviewOutlet;
//第一项
@property (weak, nonatomic) IBOutlet UIView *coverflowOutlet;
//第二项
@property (strong, nonatomic) IBOutlet UIView *usrinfo1Outlet;
//第三项
@property (strong, nonatomic) IBOutlet UIView *usrinfo2Outlet;
//第四项
@property (strong, nonatomic) IBOutlet UIView *collectionViewOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
//第五项
@property (strong, nonatomic) IBOutlet UIView *usrinfo3Outet;
@property (weak, nonatomic) IBOutlet UILabel *workexperienceOutlet;
@property (weak, nonatomic) IBOutlet UILabel *phoneOutlet;
//最后一项
@property (strong, nonatomic) IBOutlet UIView *bottomBtnView;
- (IBAction)acceptAction:(id)sender;
- (IBAction)refuseAction:(id)sender;
- (IBAction)chatAction:(id)sender;

@end

@implementation ApplyDetailVCViewController

static NSString *selectFreecellIdentifier = @"freeselectViewCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainScrollviewOutlet.delegate=self;
    [self.navigationItem setTitle:@"简历预览"];
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
//    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    [sourceImages addObject:[UIImage imageNamed:@"0.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"1.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"2.jpg"]];
    
    
    //第一项
    [self.coverflowOutlet setFrame:CGRectMake(0,0,MainScreenWidth,MainScreenWidth*0.6)];
    //背景黑
    CGRect coverflowFrame = CGRectMake(0,0,MainScreenWidth,self.coverflowOutlet.frame.size.height -20);
    //添加coverflow
    coverFlowView *cfView = [coverFlowView coverFlowViewWithFrame:coverflowFrame andImages:sourceImages sideImageCount:2 sideImageScale:0.55 middleImageScale:0.7];
    [self.coverflowOutlet addSubview:cfView];
    [self.mainScrollviewOutlet addSubview:self.coverflowOutlet];
    
    //第二项
    [self.usrinfo1Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.size.height,MainScreenWidth,110)];
    [self.mainScrollviewOutlet addSubview:self.usrinfo1Outlet];
    //第三项
    [self.usrinfo2Outlet setFrame:CGRectMake(0,self.usrinfo1Outlet.frame.origin.y+self.usrinfo1Outlet.frame.size.height,MainScreenWidth,180)];
    [self.mainScrollviewOutlet addSubview:self.usrinfo2Outlet];
    //第四项
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
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    [self.collectionViewOutlet setFrame:CGRectMake(0,self.usrinfo2Outlet.frame.origin.y+self.usrinfo2Outlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,60+freecellwidth*4)];
    [self.mainScrollviewOutlet addSubview:self.collectionViewOutlet];
    //第五项
    NSString *testworkexperience = @"IBM\n售后服务-客服\n2013年至今(2年1月)";
    NSString  *testworkexperienceFormat = [testworkexperience stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ];
    [self.workexperienceOutlet setNumberOfLines:0];
    [self.workexperienceOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testworkexperiencelabelsize = [testworkexperienceFormat sizeWithFont:[self.workexperienceOutlet font] constrainedToSize:CGSizeMake(self.workexperienceOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.workexperienceOutlet setFrame:CGRectMake(self.workexperienceOutlet.frame.origin.x,
                                                   self.workexperienceOutlet.frame.origin.y, testworkexperiencelabelsize.width, testworkexperiencelabelsize.height)];
    [self.workexperienceOutlet setText:testworkexperienceFormat];
    
    [self.usrinfo3Outet setFrame:CGRectMake(0,self.collectionViewOutlet.frame.origin.y+self.collectionViewOutlet.frame.size.height,MainScreenWidth,200)];
    [self.mainScrollviewOutlet addSubview:self.usrinfo3Outet];
    
    
    
    
//    [self.bottomBtnView setFrame:CGRectMake(0,self.usrinfo3Outet.frame.origin.y+self.usrinfo3Outet.frame.size.height,MainScreenWidth,70)];
    self.bottomBtnView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.mainScrollviewOutlet addSubview:self.bottomBtnView];
    
    //设置最终长度
    [self.mainScrollviewOutlet setContentSize:CGSizeMake(0,self.bottomBtnView.frame.origin.y+self.bottomBtnView.frame.size.height)];
}

- (void)viewWillLayoutSubviews{
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

- (void)editResume{
//    MLResumeVC *resumeVC=[[MLResumeVC alloc]init];
//    [self.navigationController pushViewController:resumeVC animated:YES];
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

//coolection
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

- (IBAction)invitationAction:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择职位"  otherButtonTitles:@"创建新职位", nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:nil animated:YES];
        
    }else if (buttonIndex == 1) {
        
        
    }else if(buttonIndex == 2) {
        
        
    }else if(buttonIndex == 3) {
        
        
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}





- (IBAction)acceptAction:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"接受" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (IBAction)refuseAction:(id)sender {
}

- (IBAction)chatAction:(id)sender {
}
@end
