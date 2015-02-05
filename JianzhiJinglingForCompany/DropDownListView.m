//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleOfPart1InSection:index:)]) {
                sectionBtnTitle = [self.dropDownDataSource titleOfPart1InSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [self addSubview:sectionBtn];
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), (self.frame.size.height-12)/2, 12, 12)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if (i<sectionNum && i != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect1 = self.mTableView1.frame;
        rect1.size.height = 0;
        CGRect rect2 = self.mTableView2.frame;
        rect2.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView1.alpha = 1.0f;
            self.mTableView2.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView1.alpha = 0.2;
            self.mTableView2.alpha = 0.2;
            
            self.mTableView1.frame = rect1;
            self.mTableView2.frame = rect2;
            
        }completion:^(BOOL finished) {
            [self.mTableView1 removeFromSuperview];
            [self.mTableView2 removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView1) {
        currentRow=0;
        
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.mTableBaseView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 240) style:UITableViewStylePlain];
        self.mTableView1.delegate = self;
        self.mTableView1.dataSource = self;
        self.mTableView1.tag = 1;
        self.mTableView1.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        self.mTableView1.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    }
    
    if (!self.mTableView2){
        self.mTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 240) style:UITableViewStylePlain];
        self.mTableView2.delegate = self;
        self.mTableView2.dataSource = self;
        self.mTableView2.tag = 2;
        self.mTableView2.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    }
    
    if ([self.dropDownDataSource numberOfRowsOfPart2InSection:currentExtendSection Row:currentRow]>0)
        self.mTableView2.hidden=NO;
    else
        self.mTableView2.hidden=YES;
    
    //修改tableview的frame
    int sectionWidth = self.frame.size.width/2;
    CGRect rect1 = self.mTableView1.frame;
    rect1.origin.x = 0;
    rect1.size.width = sectionWidth;
    rect1.size.height = 0;
    self.mTableView1.frame = rect1;
    
    CGRect rect2 = self.mTableView2.frame;
    rect2.origin.x = sectionWidth;
    rect2.size.width = sectionWidth*2;
    rect2.size.height = 0;
    self.mTableView2.frame = rect2;
    
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView1];
    [self.mSuperView addSubview:self.mTableView2];
    //动画设置位置
    rect1 .size.height = 240;
    rect2 .size.height = 240;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView1.alpha = 0.2;
        self.mTableView2.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView1.alpha = 1.0;
        self.mTableView1.frame =  rect1;
        self.mTableView2.alpha = 1.0;
        self.mTableView2.frame =  rect2;
    }];
    [self.mTableView1 reloadData];
    [self.mTableView2 reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:row:)]) {
        
        if (tableView.tag==1){
            currentRow=indexPath.row;
            if ([self.dropDownDataSource numberOfRowsOfPart2InSection:currentExtendSection Row:currentRow]>0){
                [self.mTableView2 reloadData];
                self.mTableView2.hidden=NO;
            }
            else
            {
                self.mTableView2.hidden=YES;
                NSString *chooseCellTitle =[self.dropDownDataSource titleOfPart1InSection:currentExtendSection index:indexPath.row];
                UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
                [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
                [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row row:-1];

                UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
                [UIView animateWithDuration:0.3 animations:^{
                    currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
                }];
                [self hideExtendedChooseView];
            }
        }
        
        if (tableView.tag==2){
            
            NSString *chooseCellTitle = [self.dropDownDataSource titleOfPart2InSection:currentExtendSection index:currentRow row:indexPath.row];
            UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
            [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
            
            [self.dropDownDelegate chooseAtSection:currentExtendSection index:currentRow row:indexPath.row];
            
            
            UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
            [UIView animateWithDuration:0.3 animations:^{
                currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
            }];
            [self hideExtendedChooseView];
        }

    }
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1)
        return [self.dropDownDataSource numberOfRowsOfPart1InSection:currentExtendSection];

    else{
        return [self.dropDownDataSource numberOfRowsOfPart2InSection:currentExtendSection Row:currentRow];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
        backgroundViews.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:backgroundViews];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (tableView.tag==1){
        cell.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
        cell.textLabel.text = [self.dropDownDataSource titleOfPart1InSection:currentExtendSection index:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }else if (tableView.tag==2) {
        cell.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
        cell.textLabel.text = [self.dropDownDataSource titleOfPart2InSection:currentExtendSection index:currentRow row:indexPath.row];
    }
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
