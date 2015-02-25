//
//  imageSaveAndReadUtil.m
//  wowilling
//
//  Created by 田原 on 14-3-4.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "imageSaveAndReadUtil.h"
static NSString* picFolder = @"picFolder";
@implementation imageSaveAndReadUtil
+(BOOL)writeImageToDoc:(UIImage*)image getDocName:(NSString*)docName{
    BOOL result;
    @synchronized(self) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
    result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    }
    return result;
}

+(BOOL) isExists:(NSString *)docName{
    BOOL result;
    @synchronized(self) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
        result = [fileManager fileExistsAtPath:filePath];
    }
    return result;
}
+(UIImage*)getImagePath:(NSString*)docName{
    @synchronized(self) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
    return [[UIImage alloc]initWithContentsOfFile:filePath];
    }
}
@end
