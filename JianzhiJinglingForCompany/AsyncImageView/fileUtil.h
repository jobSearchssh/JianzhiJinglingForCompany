//
//  fileUtil.h
//  wowilling
//
//  Created by 田原 on 14-3-6.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseAPP.h"
@interface fileUtil : NSObject
+(BOOL) writeFileToDoc:(NSData *)data docName:(NSString*)docName;
+(BOOL) isExists:(NSString *)docName;
+(NSData *)getFileData:(NSString*)docName;
+(void)createPicFolder;
+(void)createFileFolder;
@end
