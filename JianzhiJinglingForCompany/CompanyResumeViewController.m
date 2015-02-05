//
//  CompanyResumeViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CompanyResumeViewController.h"
#import "AKPickerView.h"
#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 10


static NSString *scrollindentify = @"scrollviewdown";


@interface CompanyResumeViewController ()
<AKPickerViewDataSource, AKPickerViewDelegate>{
    
    
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

@property (strong, nonatomic) IBOutlet UIView *view1outlet;
@property (strong, nonatomic) IBOutlet UIView *view2outlet;

@property (weak, nonatomic) IBOutlet UIScrollView *picscrollview;

@property (nonatomic, strong) MCPagerView *pageIndicator;

@end

@implementation CompanyResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"企业资料"];
    
    
    
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
    self.pageIndicator = [[MCPagerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, self.pageIndicator.frame.origin.y,100, self.indicatorcontainview.frame.size.height-5)];
    [self.pageIndicator setImage:[self compressImage:[UIImage imageNamed:@"mark1"] size:14]
                highlightedImage:[self compressImage:[UIImage imageNamed:@"mark2"] size:14]
                          forKey:@"a"];
    [self.pageIndicator setPattern:@"aaaaa"];
    
    self.pageIndicator.delegate = self;
    [self.indicatorcontainview addSubview:self.pageIndicator];
    
    //下部分
    self.scrollviewOutlet.delegate=self;
    self.pages = 2;
    
    [self createPages:self.pages];
    
    
    
    //page1
    
    //page2
    addedPicArray =[[NSMutableArray alloc]init];
    //添加图片
    UIButton *btnPic=[[UIButton alloc]initWithFrame:CGRectMake(INSETS, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setImage:[UIImage imageNamed:@"resume_add"] forState:UIControlStateNormal];
    [addedPicArray addObject:btnPic];
    [self.picscrollview addSubview:btnPic];
    [btnPic addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshScrollView];

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

- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, PIC_HEIGHT+INSETS*2);
    [self.picscrollview setContentSize:contentSize];
    [self.picscrollview setContentOffset:CGPointMake(width<self.picscrollview.frame.size.width?0:width-self.picscrollview.frame.size.width, 0) animated:YES];
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

@end
