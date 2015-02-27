//
//  MLFeedBackVC.m
//  jobSearch
//
//  Created by RAY on 15/2/5.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFeedBackVC.h"
#import "CWStarRateView.h"
#import "UMFeedback.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface MLFeedBackVC ()<CWStarRateViewDelegate,UMFeedbackDataDelegate>
{
    float value;
    CGRect rect1;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) CWStarRateView *starRateView1;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (strong, nonatomic) UMFeedback *feedback;
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
    
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
}

- (IBAction)sendFeedBack:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *feedBackString=[NSString stringWithFormat:@"评分：%.1f  评价：%@",value,self.textView.text];
    NSDictionary *postContent = @{@"content":feedBackString};
    [self.feedback post:postContent];
}

- (void)postFinishedWithError:(NSError *)error {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    if (error != nil) {
        [MBProgressHUD showError:@"反馈提交失败" toView:self.view];
    } else {
        [MBProgressHUD showSuccess:@"反馈提交成功" toView:self.view];
    }
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
