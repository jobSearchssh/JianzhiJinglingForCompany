//
//  RegexTest.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/10/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

//处理字符串 格式检验
#import <Foundation/Foundation.h>

@interface RegexTest : NSObject
+(BOOL)isIntNumber:(NSString*)numString;
+(BOOL)isValidEmail:(NSString*)emailString;
+(BOOL)isFloatNumber:(NSString*)numString;
+(BOOL)isValidMainLandPhoneNum:(NSString*)phoneString;
+(BOOL)isValidURL:(NSString*)urlString;
@end
