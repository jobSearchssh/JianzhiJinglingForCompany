//
//  MLFeedBackVC.m
//  jobSearch
//
//  Created by RAY on 15/2/5.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFeedBackVC.h"
#import "CWStarRateView.h"

@interface MLFeedBackVC ()<CWStarRateViewDelegate>
{
    float value;
    CGRect rect1;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) CWStarRateView *starRateView1;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@end

@implementation MLFeedBackVC

static  MLFeedBackVC *thisVC=nil;
+ (MLFeedBackVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLFeedBackVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.starRateView1 = [[CWStarRateView alloc] initWithFrame:CGRectMake(20, 40, [[UIScreen mainScreen] bounds].size.width-40, 40) numberOfStars:5];
    self.starRateView1.scorePercent = 1.0;
    self.starRateView1.allowIncompleteStar = NO;
    self.starRateView1.hasAnimation = YES;
    self.starRateView1.delegate=self;
    [self.view addSubview:self.starRateView1];
    value=5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillLayoutSubviews{
    self.title=@"发送反馈";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}


- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{

    value=starRateView.scorePercent*5;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.constraint.constant=-30;
    }];
}

- (void)keyboardWillhide:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constraint.constant=80;
    }];
    
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
