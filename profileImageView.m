//
//  profileImageView.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/26/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "profileImageView.h"
#import "coverFlowView.h"
@implementation profileImageView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"profileImageView" owner:self options:nil];
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[profileImageView class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.userAddressLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.userTitleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    }
    return self;
}


-(void)initCoverFlowWithDataSource:(NSArray*)userImageArray
{

    if (userImageArray!=nil) {
        CGRect childframe=CGRectMake(self.ImageCoverFlowView.frame.origin.x, self.ImageCoverFlowView.frame.origin.y,MainScreenWidth, self.ImageCoverFlowView.frame.size.height);
        
//        coverFlowView *coverFlowView = [coverFlowView coverFlowViewWithFrame:childframe andImages:userImageArray sideImageCount:4 sideImageScale:0.35 middleImageScale:0.7];
//        [self.ImageCoverFlowView addSubview:coverFlowView];
    }


}


-(void)layoutSubviews
{
 
    
}
@end
