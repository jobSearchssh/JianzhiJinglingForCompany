//
//  CALayer+urlImage.m
//  jobSearch
//
//  Created by 田原 on 15/2/16.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "CALayer+urlImage.h"
#import "AsyncImageView.h"
#define sizeHight 255

@implementation CALayer (urlImage)
-(void)loadImageWithURL:(NSString *)url{
    
    NSURL *geturl = [NSURL URLWithString:url];
    if (geturl == Nil) {
        return;
    }
    
    [[AsyncImageLoader sharedLoader]loadImageWithURL:geturl target:self action:@selector(getImage: withURL:)];
}

-(void)getImage:(UIImage *)image withURL:(NSURL *)url{
    CGSize size = CGSizeMake(sizeHight, sizeHight);
    UIImage *temp = [self scaleToSize:image size:size];
    self.contents = (__bridge id)temp.CGImage;
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
