//
//  MLResumeVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumeVC.h"
#import "AKPickerView.h"
#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 10


static NSString *scrollindentify = @"scrollviewdown";
static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface MLResumeVC ()<AKPickerViewDataSource, AKPickerViewDelegate>{
    NSMutableArray *addedPicArray;
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
}

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UIView *containTopView;
@property (weak, nonatomic) IBOutlet UIView *indicatorcontainview;

- (IBAction)continueAction:(UIButton *)sender;

@property (nonatomic, strong) MCPagerView *pageIndicator;



//下部分5个view
@property (strong, nonatomic) IBOutlet UIView *view1outlet;
@property (strong, nonatomic) IBOutlet UIView *view2outlet;
@property (strong, nonatomic) IBOutlet UIView *view3outlet;
@property (strong, nonatomic) IBOutlet UIView *view4outlet;
@property (strong, nonatomic) IBOutlet UIView *view5outlet;


//page1
@property (weak, nonatomic) IBOutlet UILabel *sexlabeloutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameoutlet;
@property (weak, nonatomic) IBOutlet UITextField *heightOutlet;
@property (weak, nonatomic) IBOutlet UITextField *iphoneOutlet;


//page2
@property (weak, nonatomic) IBOutlet UITextField *schoolOutlet;


//page3
@property (weak, nonatomic) IBOutlet UIScrollView *picscrollview;

//page4
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreetimeOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;

//page5
@property (weak, nonatomic) IBOutlet UITextField *introductionmeOutlet;
@property (weak, nonatomic) IBOutlet UITextField *workexperienceOutlet;


@end

@implementation MLResumeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //navigator

    [self.navigationItem setTitle:@"新建简历"];
    
    

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
                    [self compressImage:[UIImage imageNamed:@"resume_icon2"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon3"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon4"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon5"] size:80]
                    ];
    
    [self.pickerView reloadData];
    //indicator
    self.pageIndicator = [[MCPagerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, self.pageIndicator.frame.origin.y,100, self.indicatorcontainview.frame.size.height-5)];
    [self.pageIndicator setImage:[self compressImage:[UIImage imageNamed:@"mark1"] size:14]
       highlightedImage:[self compressImage:[UIImage imageNamed:@"mark2"] size:14]
                 forKey:@"a"];
    [self.pageIndicator setPattern:@"aaaaa"];
    
    self.pageIndicator.delegate = self;
    [self.indicatorcontainview addSubview:self.pageIndicator];
    
    //下部分
    self.scrollviewOutlet.delegate=self;
    self.pages = 5;
    
    [self createPages:self.pages];
    
    //page1
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.frame = CGRectMake(self.nameoutlet.frame.origin.x, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
    [_radio1 setTitle:@"男" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view1outlet addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.frame = CGRectMake(_radio1.frame.origin.x+_radio1.frame.size.width, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
    [_radio2 setTitle:@"女" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view1outlet addSubview:_radio2];
    
    QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio3.frame = CGRectMake(_radio2.frame.origin.x+_radio2.frame.size.width, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
    [_radio3 setTitle:@"不限" forState:UIControlStateNormal];
    [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view1outlet addSubview:_radio3];
    
    UIView *lineviewname = [[UIView alloc] initWithFrame:CGRectMake(self.nameoutlet.frame.origin.x, self.nameoutlet.frame.origin.y+self.nameoutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewname.alpha = 0.5;
    lineviewname.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewname];
    
    UIView *lineviewiphone = [[UIView alloc] initWithFrame:CGRectMake(self.iphoneOutlet.frame.origin.x, self.iphoneOutlet.frame.origin.y+self.iphoneOutlet.frame.size.height+5,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewiphone.alpha = 0.5;
    lineviewiphone.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewiphone];
    
    UIView *lineviewheight= [[UIView alloc] initWithFrame:CGRectMake(self.heightOutlet.frame.origin.x, self.heightOutlet.frame.origin.y+self.heightOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewheight.alpha = 0.5;
    lineviewheight.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewheight];
    
    self.nameoutlet.delegate = self;
    self.iphoneOutlet.delegate = self;
    self.heightOutlet.delegate = self;

    //page2
    UIView *lineviewschool= [[UIView alloc] initWithFrame:CGRectMake(self.schoolOutlet.frame.origin.x, self.schoolOutlet.frame.origin.y+self.schoolOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 60, 1)];
    lineviewschool.alpha = 0.5;
    lineviewschool.backgroundColor = [UIColor grayColor];
    [self.view2outlet addSubview:lineviewschool];
    self.schoolOutlet.delegate = self;
    
    
    
    //page3
    addedPicArray =[[NSMutableArray alloc]init];
    //添加图片
    UIButton *btnPic=[[UIButton alloc]initWithFrame:CGRectMake(INSETS, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setImage:[UIImage imageNamed:@"resume_add"] forState:UIControlStateNormal];
    [addedPicArray addObject:btnPic];
    [self.picscrollview addSubview:btnPic];
    [btnPic addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshScrollView];
    
    
    
    
    //page4
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 110)/7;
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
    
    
    
    //page5
    UIView *lineviewwork= [[UIView alloc] initWithFrame:CGRectMake(self.workexperienceOutlet.frame.origin.x, self.workexperienceOutlet.frame.origin.y+self.workexperienceOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 110, 1)];
    lineviewwork.alpha = 0.5;
    lineviewwork.backgroundColor = [UIColor grayColor];
    [self.view5outlet addSubview:lineviewwork];
    
    UIView *lineviewintroduction= [[UIView alloc] initWithFrame:CGRectMake(self.introductionmeOutlet.frame.origin.x, self.introductionmeOutlet.frame.origin.y+self.introductionmeOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 110, 1)];
    lineviewintroduction.alpha = 0.5;
    lineviewintroduction.backgroundColor = [UIColor grayColor];
    [self.view5outlet addSubview:lineviewintroduction];
    self.introductionmeOutlet.delegate = self;
    self.workexperienceOutlet.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
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
    
    [self.view3outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 2, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    [self.view4outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 3, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    [self.view5outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 4, 0,[UIScreen mainScreen].bounds.size.width, self.view1outlet.frame.size.height)];
    
    [self.scrollviewOutlet addSubview:self.view1outlet];
    [self.scrollviewOutlet addSubview:self.view2outlet];
    [self.scrollviewOutlet addSubview:self.view3outlet];
    [self.scrollviewOutlet addSubview:self.view4outlet];
    [self.scrollviewOutlet addSubview:self.view5outlet];
    
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


//page1
#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
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

- (IBAction)continueAction:(UIBarButtonItem *)sender {
    NSInteger currentpage = [self.pickerView selectedItem];
    if (currentpage == self.pages-1) {
        return;
    }
    NSInteger nextpage = currentpage+1;
    CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * nextpage, self.scrollviewOutlet.contentOffset.y);
    [self.scrollviewOutlet setContentOffset:offset animated:YES];
    self.pageIndicator.page = nextpage;
    [self.pickerView selectItem:nextpage animated:YES];
}
//page3
- (IBAction)addPicAction:(UIButton *)sender {
    
    //添加图片
    UIButton *btnPic=[[UIButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [btnPic setFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [addedPicArray addObject:btnPic];
    [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
    [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.picscrollview addSubview:btnPic];
    
    for (UIButton *btn in addedPicArray) {
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [btn.layer addAnimation:positionAnim forKey:nil];
        
        [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
    }
    [self refreshScrollView];
}

-(IBAction)deletePicAction:(UIButton *)sender{
    NSInteger btnindex = [sender restorationIdentifier].integerValue;
    UIButton *btn = [addedPicArray objectAtIndex:btnindex];
    [btn removeFromSuperview];
    for (UIButton *tempbtn in addedPicArray) {
        if ([tempbtn restorationIdentifier].intValue > btnindex) {
            [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue == btnindex) {
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue < btnindex) {
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [tempbtn.layer addAnimation:positionAnim forKey:nil];
            [tempbtn setCenter:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)];
        }
    }
    [addedPicArray removeObjectAtIndex:btnindex];
    [self refreshScrollView];
}
- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, PIC_HEIGHT+INSETS*2);
    [self.picscrollview setContentSize:contentSize];
    [self.picscrollview setContentOffset:CGPointMake(width<self.picscrollview.frame.size.width?0:width-self.picscrollview.frame.size.width, 0) animated:YES];
}

//page4
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


@end
