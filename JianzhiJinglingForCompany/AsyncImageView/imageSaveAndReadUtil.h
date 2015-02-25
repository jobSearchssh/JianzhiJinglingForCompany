//
//  imageSaveAndReadUtil.h
//  wowilling
//
//  Created by 田原 on 14-3-4.
//  Copyright (c) 2014年 田原. All rights reserved.
//
//  图片本地化
#import <UIKit/UIKit.h>

@interface imageSaveAndReadUtil : NSObject
+(BOOL) writeImageToDoc:(UIImage*)image getDocName:(NSString*)docName;
+(BOOL) isExists:(NSString *)docName;
+(UIImage*)getImagePath:(NSString*)docName;
@end
