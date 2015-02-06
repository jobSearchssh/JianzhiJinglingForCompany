//
//  baseAPP.h
//  wowilling
//
//  Created by 田原 on 14-3-5.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseAPP : NSObject

-(id)init;

+(NSOperationQueue *)getBaseNSOperationQueue;
+(void)setUsrID:(NSString *)setUsrID;
+(NSString *)getUsrID;

@end
