//
//  imageButton.m
//  jobSearch
//
//  Created by 田原 on 15/2/15.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "imageButton.h"
#import "AsyncImageView.h"
#define  PIC_HEIGHT 60

@implementation imageButton
-(int)getStatus{
    return status;
}
-(void)setStatus:(int)value{
    status = value;
}

-(void)seturl:(NSString *)value{
    buttomURL = value;
}
-(NSString *)geturl{
    return buttomURL;
}

-(void)loadImageWithURL:(NSString *)url{
    
    NSURL *geturl = [NSURL URLWithString:url];
    if (geturl == Nil) {
        return;
    }
    
    [[AsyncImageLoader sharedLoader]loadImageWithURL:geturl target:self action:@selector(getImage: withURL:)];
}

-(void)getImage:(UIImage *)image withURL:(NSURL *)url{
    CGSize size = CGSizeMake(PIC_HEIGHT, PIC_HEIGHT);
    UIImage *temp = [self scaleToSize:image size:size];
    [self setBackgroundImage:temp forState:UIControlStateNormal];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
