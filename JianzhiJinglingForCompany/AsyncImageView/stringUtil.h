//
//  stringUtil.h
//  myPassWordWallet
//
//  Created by 田原 on 14-2-27.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stringUtil : NSObject
+(NSString*)formatMyString:(NSString *)getString;
+(BOOL)isEmpty:(NSString *)string;
+(NSUInteger) lenghtWithString:(NSString *)string;
@end
