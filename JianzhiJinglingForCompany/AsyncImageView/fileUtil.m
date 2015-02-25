//
//  fileUtil.m
//  wowilling
//
//  Created by 田原 on 14-3-6.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "fileUtil.h"
static NSString* picFolder = @"picFolder";
@implementation fileUtil
+(BOOL) writeFileToDoc:(NSData *)data docName:(NSString*)docName{
    @synchronized(self) {
        @try {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
            BOOL result = [data writeToFile:filePath atomically:YES];
            return result;
        }
        @catch (NSException *exception) {
            return FALSE;
        }
    
    }
}

+(BOOL) isExists:(NSString *)docName{
    @synchronized(self) {
        @try {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            return [fileManager fileExistsAtPath:filePath];
        }
        @catch (NSException *exception) {
            return FALSE;
        }
    
    }
}

+(NSData *)getFileData:(NSString*)docName{
    @synchronized(self) {
        @try {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png",picFolder,docName]];
            NSData *data=[NSData dataWithContentsOfFile:filePath options:0 error:NULL];
            return data;            
        }
        @catch (NSException *exception) {
            return Nil;
        }
    }
}

+(void)createPicFolder{
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picFolder];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if (![fileManager fileExistsAtPath:filePath]) {
            if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:Nil error:&error]) {
                NSLog(@"%@",error);
            }else{
                NSLog(@"新建图片文件夹成功");
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}

+(void)createFileFolder{
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picFolder];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if (![fileManager fileExistsAtPath:filePath]) {
            if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:Nil error:&error]) {
                NSLog(@"%@",error);
            }else{
                NSLog(@"新建file文件夹成功");
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}
@end
