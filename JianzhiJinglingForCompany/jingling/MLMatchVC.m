//
//  MLMatchVC.m
//  jobSearch
//
//  Created by RAY on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//
#import "MLMatchVC.h"
#import "RSCircaPageControl.h"
#import "PiPeiView.h"
#import "MBProgressHUD.h"
#import "netAPI.h"
#import "UIViewController+LoginManager.h"
#import "PageSplitingManager.h"
//static NSString *userId = @"54d76bd496d9aece6f8b4568";


@interface RSView : UIView
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation RSView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self) {
        return self.scrollView;
    }
    return child;
}

@end


@interface MLMatchVC ()<UIScrollViewDelegate,childViewDelegate>
{
    int kScrollViewHeight;
    int kScrollViewContentHeight;
    int kScrollViewTagBase;
    
    NSMutableArray *recordArray;
     NSMutableArray *childViewArray;
    
    BOOL isLoadSusseed;
    
}

@property (nonatomic, strong) RSView *clipView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RSCircaPageControl *pageControl;
@property (nonatomic,strong)PageSplitingManager *pageManager;
@end

@implementation MLMatchVC

-(PageSplitingManager*)pageManager
{
    if (_pageManager==nil) {
        _pageManager=[[PageSplitingManager alloc]initWithPageSize:5];
    }
    return  _pageManager;
}

static  MLMatchVC *thisVC=nil;

+ (MLMatchVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLMatchVC alloc]init];
    }
    return thisVC;
}

- (void)viewWillLayoutSubviews{
    self.title=@"精灵管家";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLoadData) name:@"autoLoadNearData" object:nil];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    [self.navigationItem.rightBarButtonItem setTitle:@"今日刷新"];
    
    
    kScrollViewHeight = [[UIScreen mainScreen]bounds].size.height;
    kScrollViewContentHeight=kScrollViewHeight;
    kScrollViewTagBase=kScrollViewHeight;
    
    recordArray=[[NSMutableArray alloc]init];
     childViewArray=[[NSMutableArray alloc]init];
    
    self.clipView = [[RSView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.clipView.clipsToBounds = YES;
    [self.view addSubview:self.clipView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.clipView.bounds.size.width, kScrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    self.clipView.scrollView = self.scrollView;
    
    self.pageControl = [[RSCircaPageControl alloc] initWithNumberOfPages:5];
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.view.bounds.size.width - frame.size.width - 10;
    frame.origin.y = roundf((self.view.bounds.size.height - frame.size.height) / 2.);
    self.pageControl.frame = frame;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.pageControl setCurrentPage:0 usingScroller:NO];
    [self.view addSubview:self.pageControl];
    
    
    
    [self initData];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)refreshScrollView{
    if ([recordArray count]>0) {
    self.scrollView.hidden=NO;
    CGFloat currentY = 0;
    PiPeiView* childView=[[PiPeiView alloc]init];
    [childView.view setFrame:CGRectMake(0, currentY, self.scrollView.bounds.size.width, kScrollViewHeight-104)];
    
    childView.view.tag = kScrollViewTagBase;
    childView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:childView];
    [self.scrollView addSubview:childView.view];
    for (int i = 0; i < [recordArray count]; i++) {
        
        PiPeiView* childView=[[PiPeiView alloc]init];
        childView.childViewDelegate=self;
        [self addChildViewController:childView];
        
        [childView.view setFrame:CGRectMake(0, currentY, self.scrollView.bounds.size.width, kScrollViewHeight-44)];
        
        childView.view.tag = kScrollViewTagBase + i;
        
        childView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        userModel *_userModel=[recordArray objectAtIndex:i];
        
        if (_userModel) {
            
            childView.userModel=_userModel;
            childView.index=i;
            
            
            [childView initData];
        }
        [self.scrollView addSubview:childView.view];
        [childViewArray addObject:childView.view];
        currentY += kScrollViewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, currentY);
    }
    else
    {
        self.scrollView.hidden=YES;
    
    }
}

- (void)initData{
    if (![UIViewController isLogin]) {
        [self notLoginHandler];
        return;
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSUserDefaults *mysetting=[NSUserDefaults standardUserDefaults];
        NSString *com_id=[mysetting objectForKey:CURRENTUSERID];
        [netAPI getjinglingMatch:com_id start:[self.pageManager getNextStartAt] length:self.pageManager.pageSize  withBlock:^(userListModel *userListModel) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[userListModel getStatus] intValue]==BASE_SUCCESS) {
                if ([[userListModel getuserArray]count]<1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Text_NoSuitableUser message:[userListModel getInfo] delegate:nil cancelButtonTitle:Text_ConfirmBrntext otherButtonTitles:nil];
                    [alert show];
                }else
                {
                    for (userModel *user in [userListModel getuserArray]) {
                        [recordArray addObject:user];
                    }
                    isLoadSusseed=YES;
                    [self.pageManager pageLoadCompleted];
                    [self refreshScrollView];
                }
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配没有成功" message:[userListModel getInfo] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    [self refreshScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        float percentage = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height);
        [self.pageControl updateScrollerAtPercentage:percentage animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        int index = (int)(scrollView.contentOffset.y / kScrollViewHeight);
        [self.pageControl setCurrentPage:index usingScroller:NO];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refresh
{
    if (isLoadSusseed) {
        ALERT(Text_NotPermitRefresh);
    }
    else
    {
        [self.pageManager resetPageSplitingManager];
        [self initData];
    }
}
- (void)deleteJob:(int)index{
    
    if (index>=0&&index<[recordArray count]) {
        
        [[childViewArray objectAtIndex:index] removeFromSuperview];
        
        for (int i=index+1;i<[recordArray count];i++ ) {
            UIView *currentView=[childViewArray objectAtIndex:i];
            
            [UIView animateWithDuration:0.2 animations:^{
                [currentView setCenter:CGPointMake(currentView.center.x, currentView.center.y-kScrollViewHeight)];
            }];
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height-kScrollViewHeight);
        [recordArray removeObjectAtIndex:index];
        [self refreshScrollView];
    }
}


-(void)autoLoadData
{
    [self.pageManager resetPageSplitingManager];
    [self initData];
}


@end
