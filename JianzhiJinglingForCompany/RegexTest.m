//
//  RegexTest.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/10/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//


#import "RegexTest.h"

@implementation RegexTest



#pragma --mark  正则匹配非负整数
+(BOOL)isIntNumber:(NSString*)numString
{
    NSString *intnumberRegex=@"^-?[1-9]\\d*$";
    NSPredicate  *numTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",intnumberRegex];
    return [numTest evaluateWithObject:numString];
}

#pragma --mark  匹配邮箱
+(BOOL)isValidEmail:(NSString*)emailString
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:emailString];
    return isValid;
}

#pragma --mark  正则匹配浮点数
+(BOOL)isFloatNumber:(NSString*)numString
{
    NSString* floatNumRegex = @"^-?([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0)$";
    NSPredicate* floatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", floatNumRegex];
    return [floatTest evaluateWithObject:numString];

}

#pragma --mark  匹配电话号码
+(BOOL)isValidMainLandPhoneNum:(NSString*)phoneString
{
    NSString* phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneString];
}

#pragma --mark  匹配URL
+(BOOL)isValidURL:(NSString*)urlString
{
    NSString *urlRegex=@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlText=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    
    return  [urlText evaluateWithObject:urlString];
}




@end
