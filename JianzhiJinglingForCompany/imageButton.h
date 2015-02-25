//
//  imageButton.h
//  jobSearch
//
//  Created by 田原 on 15/2/15.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#define uploadOK 0
#define uplaoding 1
#define uploaderror 2
#define fromNet 3

@interface imageButton : UIButton{
    int status;
    NSString *buttomURL;
}
-(void)seturl:(NSString *)value;
-(NSString *)geturl;
-(int)getStatus;
-(void)setStatus:(int)value;
-(void)loadImageWithURL:(NSString *)url;
@end
