//
//  ComProfileViewController.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "ComProfileViewController.h"
#import "CompanyResumeViewController.h"
@interface ComProfileViewController ()

@end

@implementation ComProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
    
    
    
    
}





-(void)editResume
{
    CompanyResumeViewController *editVC=[[CompanyResumeViewController alloc]init];
    
    [self.navigationController pushViewController:editVC animated:YES];

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
