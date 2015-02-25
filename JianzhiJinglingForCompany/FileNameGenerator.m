//
//  FileNameGenerator.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "FileNameGenerator.h"

@implementation FileNameGenerator
+(NSString*)getNameForNewFile
{
    //自动生成8位随机码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSLog(@"now:%.8f",random);
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    NSLog(@"randompassword:%@",randompassword);
    //生成对应MD5
    NSString *newName=[MyMD5 md5:randompassword];
    return newName;
}
@end
