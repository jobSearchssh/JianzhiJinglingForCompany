//
//  MLFilterVC.m
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFilterVC.h"
//#import "MLSelectJobTypeVC.h"

@interface MLFilterVC ()<UINavigationControllerDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSeg;
@property (nonatomic) int distance;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong,nonatomic) NSMutableArray *typeArray;
@end

@implementation MLFilterVC

static  MLFilterVC *thisVC=nil;

+ (MLFilterVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLFilterVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.typeArray=[[NSMutableArray alloc]init];
    self.distance=20;
    self.distanceSeg.selectedSegmentIndex=4;
}

- (void)done{
    
    [self.filterDelegate finishFilter:self.distance Length:12];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)selectDistance:(id)sender {
    
    if ((long)self.distanceSeg.selectedSegmentIndex==0) {
        self.distance=1;
    }else if ((long)self.distanceSeg.selectedSegmentIndex==1)
        self.distance=3;
    else if ((long)self.distanceSeg.selectedSegmentIndex==2)
        self.distance=5;
    else if ((long)self.distanceSeg.selectedSegmentIndex==3)
        self.distance=10;
    else if ((long)self.distanceSeg.selectedSegmentIndex==4)
        self.distance=20;
}

- (IBAction)setApplicationType:(id)sender {
//    MLSelectJobTypeVC *selectVC=[MLSelectJobTypeVC sharedInstance];
//    selectVC.selectDelegate=self;
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    self.navigationItem.backBarButtonItem = backItem;
//    [self.navigationController pushViewController:selectVC animated:YES];
}


- (void)finishSelect:(NSMutableArray *)type SelectName:(NSMutableArray *)nameArray{
    if([type count]>0){
        self.typeArray=type;
        
        NSString *typeString=[[NSString alloc]init];
        for (NSString *str in nameArray ) {
            typeString=[typeString stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
        }
        self.typeLabel.text=[NSString stringWithFormat:@"%@",typeString];
    }
    else {
        self.typeLabel.text=@"全部";
        [self.typeArray removeAllObjects];
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
