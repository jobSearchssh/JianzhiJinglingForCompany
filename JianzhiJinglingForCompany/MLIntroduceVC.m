//
//  MLIntroduceVC.m
//  jobSearch
//
//  Created by RAY on 15/2/28.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLIntroduceVC.h"
#import "MainTabBarViewController.h"
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)

@interface MLIntroduceVC ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MLIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    self.scrollView.delegate=self;
    self.scrollView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.pages = 4;
    
    KVNMaskedPageControl *pageControl = [[KVNMaskedPageControl alloc] init];
    [pageControl setNumberOfPages:self.pages];
    
    if (!DEVICE_IS_IPHONE4) {
        [pageControl setCenter:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]) - CGRectGetMidY(pageControl.bounds) - 10)];
    }else{
        [pageControl setCenter:CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), 470)];
    }
    [pageControl setDataSource:self];
    [pageControl setHidesForSinglePage:YES];
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    [self createPages:self.pages];
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

}

-(void)touchStart{
    
    if((![[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"])||![[[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]){
        
        [UIView animateWithDuration:0.7 animations:^{
            _scrollView.alpha=0;
        } completion:^(BOOL finished) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"launchFirstTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            
            MainTabBarViewController * _mainTabberVC=[MainTabBarViewController shareInstance];

            window.rootViewController = _mainTabberVC;
        }];
    }
}


- (void)createPages:(NSInteger)pages {
    
    for (int i = 0; i < pages; i++) {
        UIImageView *imgView;
        
        UIImage *img;
        if (!DEVICE_IS_IPHONE4) {
            imgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * i, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]))];
            img=[UIImage imageNamed:[NSString stringWithFormat:@"intro_%d.png",i+1]];
        }else{
            imgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds) * i, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 480)];
            img=[UIImage imageNamed:[NSString stringWithFormat:@"intro_%d.png",i+1]];
        }
        imgView.image=img;
        [self.scrollView addSubview:imgView];
        if (i==3) {
            UIButton *btn=[[UIButton alloc]init];
            
            btn.frame= CGRectMake(213*[[UIScreen mainScreen] bounds].size.width/960, 1433*[[UIScreen mainScreen] bounds].size.height/1704, 543*[[UIScreen mainScreen] bounds].size.width/960, 112*[[UIScreen mainScreen] bounds].size.height/1704);
            
            btn.titleLabel.text=@"";
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(touchStart) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:btn];
            imgView.userInteractionEnabled=YES;
        }
//        if (i==3) {
//            UIButton *btn=[[UIButton alloc]init];
//            if (DEVICE_IS_IPHONE5) {
//                btn.frame= CGRectMake(100, 430, 120, 40);
//            }else{
//                btn.frame= CGRectMake(100, 382, 120, 40);
//            }
//            btn.titleLabel.text=@"btnnto";
//            btn.backgroundColor=[UIColor clearColor];
//            [btn addTarget:self action:@selector(touchStart) forControlEvents:UIControlEventTouchUpInside];
//            [imgView addSubview:btn];
//            imgView.userInteractionEnabled=YES;
//        }
    }
    if (!DEVICE_IS_IPHONE4) {
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * pages, CGRectGetHeight([[UIScreen mainScreen] bounds]))];
    }
    else{[self.scrollView setContentSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * pages, 480)];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl maskEventWithOffset:scrollView.contentOffset.x frame:scrollView.frame];
    
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    if (self.scrollView.contentOffset.x>(self.pages-1)*pageWidth+pageWidth/4) {
        [self touchStart];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger page =  floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger page =  floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.pageControl setCurrentPage:page];
}

#pragma mark - IBActions
- (void)changePage:(KVNMaskedPageControl *)sender {
    self.pageControl.currentPage = sender.currentPage;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - KVNMaskedPageControlDataSource
- (UIColor *)pageControl:(KVNMaskedPageControl *)control pageIndicatorTintColorForIndex:(NSInteger)index {
    return [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
}

- (UIColor *)pageControl:(KVNMaskedPageControl *)control currentPageIndicatorTintColorForIndex:(NSInteger)index {
    return [UIColor colorWithRed:255/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
