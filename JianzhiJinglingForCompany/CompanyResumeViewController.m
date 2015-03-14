//
//  CompanyResumeViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CompanyResumeViewController.h"
#import "AKPickerView.h"
#import "netAPI.h"
#import "HZAreaPickerView.h"
#import "ZHPickView.h"
#import <BmobSDK/Bmob.h>
#import "UIViewController+HUD.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "enterpriseDetailModel.h"
#import "MLLocationServiceManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "FileNameGenerator.h"
#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 10
#define CANCELEDITALERTTAG 12212

static NSString *scrollindentify = @"scrollviewdown";


@interface CompanyResumeViewController ()
<AKPickerViewDataSource, AKPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,AMapSearchDelegate,MAMapViewDelegate>{
    NSMutableArray *addedPicArray;
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
    
    NSString *province;
    NSString *city;
    NSString *district;
    NSString *detailAddress;
    NSString *imageUrl;
    
    NSString *fileTempPath;
    
    BOOL wantedUpdateLocation;
    geoModel *newGeo;
}
@property (strong,nonatomic)AMapSearchAPI *search;

@property(strong,nonatomic)enterpriseDetailModel *newenterprise;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UITextField *comAddressTextField;

@property (nonatomic,strong)ZHPickView *industryTypePicker;
@property (weak, nonatomic) IBOutlet UIView *containTopView;
@property (weak, nonatomic) IBOutlet UIView *indicatorcontainview;

- (IBAction)continueAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *view1outlet;
@property (strong, nonatomic) IBOutlet UIView *view2outlet;

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

- (IBAction)addImageBtnAction:(id)sender;

@property (nonatomic, strong) MCPagerView *pageIndicator;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *choiceDistrictBtn;
- (IBAction)choiceDistrictAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choiceIndustryBtn;
- (IBAction)choiceIndustryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *companyIntroTextView;
- (IBAction)commitBtnAction:(id)sender;
- (IBAction)cancelEditAndBackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelEditBtnWhenModally;

- (IBAction)upDateLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitBtnWhenModally;

@end

@implementation CompanyResumeViewController

-(AMapSearchAPI*)search
{
    if (_search==nil) {
        //初始化检索对象
        [MAMapServices sharedServices].apiKey=@"7940ad72b6cad048cd56b9eef4495d81";
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"7940ad72b6cad048cd56b9eef4495d81" Delegate:self];
        _search.delegate=self;
    }
    return _search;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"企业资料"];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.autoresizesSubviews=UIViewAutoresizingFlexibleWidth;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(commitEdit)];
    [self.navigationItem.rightBarButtonItem setTitle:@"提交"];
    
    //上部分
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.containTopView.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.containTopView addSubview:self.pickerView];
    [[self.containTopView window]makeKeyAndVisible];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyleFlat;
    
    self.titles = @[[self compressImage:[UIImage imageNamed:@"resume_icon1"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon3"] size:80]
                    ];
    
    [self.pickerView reloadData];
    //indicator
    self.pageIndicator = [[MCPagerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-10, self.pageIndicator.frame.origin.y,100, self.indicatorcontainview.frame.size.height-5)];
    [self.pageIndicator setImage:[self compressImage:[UIImage imageNamed:@"mark1"] size:14]
                highlightedImage:[self compressImage:[UIImage imageNamed:@"mark2"] size:14]
                          forKey:@"a"];
    [self.pageIndicator setPattern:@"aa"];
    
    self.pageIndicator.delegate = self;
    [self.indicatorcontainview addSubview:self.pageIndicator];
    
    //下部分
    self.scrollviewOutlet.delegate=self;
    self.pages = 2;
    
    [self createPages:self.pages];
    [self loadDataFromUpper];
    
    
    wantedUpdateLocation=NO;
    
    if (self.isPushedOut) {
        
        self.cancelEditBtnWhenModally.hidden=YES;
        self.submitBtnWhenModally.hidden=YES;
        
    }
    //page1
    
    
    
    //page2
    
    
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


#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}


-(BOOL)writeImageToDoc:(UIImage*)image{
    BOOL result;
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        fileTempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[FileNameGenerator getNameForNewFile]]];
        result = [UIImagePNGRepresentation(image)writeToFile:fileTempPath atomically:YES];
    }
    return result;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    UIImage *temp = image;
    if (image.size.height > PIC_HEIGHT || image.size.width>PIC_WIDTH) {
        CGSize size = CGSizeMake(320, 320);
        temp = [self scaleToSize:image size:size];
    }
    picker = Nil;
    [self dismissModalViewControllerAnimated:YES];
    if (![self writeImageToDoc:image]) {
        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:Text_Note message:Text_WriteFile delegate:nil cancelButtonTitle:Text_GetKnownText otherButtonTitles:nil];
        [alterTittle show];
    }else{
        [self.imageBtn setBackgroundImage:temp forState:UIControlStateNormal];
        //上传图片
        [BmobFile filesUploadBatchWithPaths:@[fileTempPath]
                              progressBlock:^(int index, float progress) {
                                  
                                  //                                  [self showHudInView:self.view hint:[NSString stringWithFormat:@"上传:%ld％",(long)(progress*100)]];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self showHudInView:self.view hint:[NSString stringWithFormat:@"Loading:%ld％",(long)(progress*100)]];
                                      if (progress==1) {
                                          [self hideHud];
                                      }
                                  });
                              } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                  if (isSuccessful) {
                                      NSString *imageTemp = Nil;
                                      for (int i = 0 ; i < array.count ;i ++) {
                                          BmobFile *file = array [i];
                                          imageTemp = [file url];
                                          if (imageTemp != Nil) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  imageUrl=imageTemp;
                                                  [MBProgressHUD showError:Text_UpLoadSuccess toView:self.view];
                                              });
                                          }else{
                                              [self hideHud];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD showError:Text_UpLoadError toView:self.view];
                                              });
                                          }
                                      }
                                      
                                  }else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD showError:Text_UpLoadError toView:self.view];
                                      });
                                  }
                              }];
    }
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

//- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
//{
//	return self.titles[item];
//}


- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
{
    return self.titles[item];
}


#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    self.pageIndicator.page = item;
    CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * item, self.scrollviewOutlet.contentOffset.y);
    [self.scrollviewOutlet setContentOffset:offset animated:YES];
    [pickerView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    province=picker.locate.state;
    city=picker.locate.city;
    district=picker.locate.district;
    //    [self.jobPlaceLabel setTitle:addr forState:UIControlStateNormal];
    if (province==nil && city!=nil) {
        province=city;
    }
    else if (city==nil && province!=nil) {
        //        [self.thisJob setjobWorkCity:province];
        city=province;
    }
    else{
        [self.choiceDistrictBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,district] forState:UIControlStateNormal];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */


- (void)createPages:(NSInteger)pages {
    
    [self.view1outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 0, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    [self.view2outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 1, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    //    [self.view3outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 2, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    //
    //    [self.view4outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 3, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    //
    //    [self.view5outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 4, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    [self.scrollviewOutlet addSubview:self.view1outlet];
    [self.scrollviewOutlet addSubview:self.view2outlet];
    //    [self.scrollviewOutlet addSubview:self.view3outlet];
    //    [self.scrollviewOutlet addSubview:self.view4outlet];
    //    [self.scrollviewOutlet addSubview:self.view5outlet];
    
    CGFloat scrennHeight = [UIScreen mainScreen].bounds.size.height;
    
    if(scrennHeight < 481){
        [self.scrollviewOutlet setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * pages, CGRectGetHeight([UIScreen mainScreen].bounds))];
    }else{
        [self.scrollviewOutlet setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * pages, 0)];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([[scrollView restorationIdentifier] isEqualToString:scrollindentify]) {
        NSInteger page = floorf(self.scrollviewOutlet.contentOffset.x / self.scrollviewOutlet.frame.size.width);
        CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * page, self.scrollviewOutlet.contentOffset.y);
        [self.scrollviewOutlet setContentOffset:offset animated:YES];
        self.pageIndicator.page = page;
        [self.pickerView selectItem:page animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([[scrollView restorationIdentifier] isEqualToString:scrollindentify]) {
        if (!decelerate) {
            NSInteger page = floorf(self.scrollviewOutlet.contentOffset.x / self.scrollviewOutlet.frame.size.width);
            CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * page, self.scrollviewOutlet.contentOffset.y);
            [self.scrollviewOutlet setContentOffset:offset animated:YES];
            self.pageIndicator.page = page;
            [self.pickerView selectItem:page animated:YES];
            //[self.pickerView reloadData];
        }
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

- (IBAction)addImageBtnAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:Text_CancelBtnText
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:Text_ChoosePhoto,Text_TakingPhoto,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
}
- (IBAction)choiceDistrictAction:(id)sender {
    [self cancelLocatePicker];
    
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    self.locatePicker.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [self.locatePicker showInView:self.view];
}
- (IBAction)choiceIndustryAction:(id)sender {
}


- (IBAction)continueAction:(UIButton *)sender
{
    
}




-(void)loadDataFromUpper
{
    if(self.enterprise==nil)
    {
        return;
    }else
    {
        self.companyNameTextField.text=[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseName]];
        [self.choiceDistrictBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",[self.enterprise getenterpriseProvince],[self.enterprise getenterpriseCity],[self.enterprise getenterpriseDistrict]] forState:UIControlStateNormal];
        
        self.comAddressTextField.text=[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseAddressDetail]];
        
        
        self.companyIntroTextView.text=[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseIntroduction]];
        
        
#warning 加载图片（待完善）
        
    }
}



-(void)checkDataBeforePerformCommit
{
    self.newenterprise=[[enterpriseDetailModel alloc]init];
    //企业名称
    if (self.companyNameTextField.text!=nil) {
        [self.newenterprise setenterpriseName:self.companyNameTextField.text];
    }else if (self.enterprise!=nil)
    {
        [self.newenterprise setenterpriseName:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseName]]];
    }else
    {
        ALERT(Text_AddName);
        return;
    }
    //选择城市
    if(province!=nil && city !=nil && district!=nil)
    {
        [self.newenterprise setenterpriseProvince:province];
        [self.newenterprise setenterpriseCity:city];
        [self.newenterprise setenterpriseDistrict:district];
    }else if(self.enterprise!=nil)
    {
        [self.newenterprise setenterpriseProvince:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseProvince]]];
        [self.newenterprise setenterpriseCity:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseCity]]];
        [self.newenterprise setenterpriseDistrict:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseDistrict]]];
    }else
    {
        ALERT(Text_AddZone);
        return;
    }
    //详细地址
    if(self.comAddressTextField.text!=nil)
    {
        [self.newenterprise setenterpriseAddressDetail:self.comAddressTextField.text];
    }else if(self.enterprise!=nil)
    {
        [self.newenterprise setenterpriseAddressDetail:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseAddressDetail]]];
    }else
    {
        ALERT(Text_AddAddress);
        return;
    }
    
    //企业介绍
    if(self.companyIntroTextView.text!=nil)
    {
        [self.newenterprise setenterpriseIntroduction:self.companyIntroTextView.text];
        
    }else if(self.enterprise!=nil)
    {
        [self.newenterprise setenterpriseAddressDetail:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseIntroduction]]];
    }else
    {
        ALERT(Text_AddIntro);
        return;
    }
    //公司图片
    if (imageUrl!=nil) {
        [self.newenterprise setenterpriseLogoURL:imageUrl];
    }else if(self.enterprise!=nil)
    {
        [self.newenterprise setenterpriseLogoURL:[NSString stringWithFormat:@"%@",[self.enterprise getenterpriseLogoURL]]];
    }
    else
    {
        ALERT(Text_AddPhoto);
        return;
    }
    
    //一下为默认设置
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSString *com_id=[mysettings objectForKey:CURRENTUSERID];
    [self.newenterprise setgetenterprise_id:com_id];
    
    [self.newenterprise setenterpriseInviteTypes:@"0"];
    [self.newenterprise  setenterpriseIndustry:[NSNumber numberWithInt:0]];
    geoModel *geo;
    if (wantedUpdateLocation) {
        //更新新的位置信息
        if(newGeo==nil)
        {
            ALERT(Text_LocateErrorAndRetry);
            return;
        }
        [self.newenterprise setgeoModel:geo];
    }
    else if (self.enterprise!=nil) {
        geo=[self.enterprise getGeo];
        if (geo==nil) {
            ALERT(Text_LocateErrorAndRetry);
            return;
        }
        else{
            [self.newenterprise setgeoModel:geo];
        }
    }
    [self doCommit];
    wantedUpdateLocation=NO;
}

-(void)doCommit
{
    [self showHudInView:self.view hint:Text_Commiting];
    
    [netAPI createOrEditEnterpriseInfo:self.newenterprise withBlock:^(ceateOrEditInfoModel *createEditModel) {
        [self hideHud];
        if ([[createEditModel getStatus]intValue]==BASE_SUCCESS) {
            
            [self dismissingThisVCWithComletion:^{
                NSUserDefaults  *mysetings=[NSUserDefaults standardUserDefaults];
                [mysetings setBool:YES forKey:COMPROFILEFlag];
                [mysetings synchronize];
                ALERT(Text_ModfySuccess);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"资料修改成功" object:nil  userInfo:@{@"item":self.newenterprise }];
            }];
        }
        else
        {
            NSString *error=[NSString stringWithFormat:@"%@",[createEditModel getInfo]];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:Text_loadError message:error delegate:self cancelButtonTitle:Text_Back otherButtonTitles:Text_OK, nil];
            alertView.tag=CANCELEDITALERTTAG;
            [alertView show];
        }
    }];
}

//提交
-(void)commitEdit
{
    [self checkDataBeforePerformCommit];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case CANCELEDITALERTTAG:
        {
            if (buttonIndex) {
                [self dismissingThisVCWithComletion:nil];
            }
        }
            break;
            
        default:{
            if (buttonIndex) {
                [self checkDataBeforePerformCommit];
            }
            break;
        }
    }
    
    
}


//action
//tag == 0 为选择图片按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:Text_Note message:Text_NoCamera delegate:nil cancelButtonTitle:Text_GetKnownText otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
    }
    else if (actionSheet.tag==1) {
        
    }
}

//action响应事件
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


- (IBAction)commitBtnAction:(id)sender {
    
    [self commitEdit];
}

- (IBAction)cancelEditAndBackAction:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upDateLocation:(id)sender {
    wantedUpdateLocation=YES;
    [self showHudInView:self.view hint:Text_Locating];
    MLLocationServiceManager *manager=[MLLocationServiceManager shareInstance];
    [manager startLocationServiceWithCompleteBlock:^{
        [self hideHud];
        [MBProgressHUD showError:Text_LocateSuccess toView:self.view];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString *geoString1=[mySettingData objectForKey:CURRENTLOCATOIN];
        CGPoint p2=CGPointFromString(geoString1);
        newGeo=[[geoModel alloc]initWith:p2.x lat:p2.y];
        
        //初始化检索对象
        
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        
        CLLocationCoordinate2D locationCorrrdinate=CLLocationCoordinate2DMake((CLLocationDegrees)[newGeo getLat], (CLLocationDegrees)[newGeo getLon]);
        
        regeoRequest.location=[AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        ;
        //发起逆地理编码
        [self.search AMapReGoecodeSearch: regeoRequest];
    } Error:^{
        [self hideHud];
        [MBProgressHUD showError:Text_LocateError toView:self.view];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString *geoString=[mySettingData objectForKey:CURRENTLOCATOIN];
        CGPoint p2=CGPointFromString(geoString);
        newGeo=[[geoModel alloc]initWith:p2.x lat:p2.y];
        //        [self.newenterprise setgeoModel:geo];
        //        [self doCommit];
    }];
}

-(void)errorHideHudAfterDelay
{
    [self hideHud];
    ALERT(Text_Timeout);
    //    [self.thisJob setjobWorkProvince:@"北京"];
    //    [self.thisJob setjobWorkCity:@"北京市"];
    //    [self.thisJob setjobWorkDistrict:@"朝阳区"];
    
}





//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self hideHud];
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        [self.choiceDistrictBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district]
                                forState:UIControlStateNormal];
        
        province=response.regeocode.addressComponent.province?response.regeocode.addressComponent.province:response.regeocode.addressComponent.city;
        city=response.regeocode.addressComponent.city?response.regeocode.addressComponent.city:response.regeocode.addressComponent.province;
        district=response.regeocode.addressComponent.district;
        
        
    }
}


-(void)dismissingThisVCWithComletion:(void(^)(void))block
{
    if (self.isPushedOut) {
        block();
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        //dismiss Modally
        [self dismissViewControllerAnimated:YES completion:^{
            block();
        }];
    }
}

@end
