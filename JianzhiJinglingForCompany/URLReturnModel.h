//
//  URLReturnModel.h
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLReturnModel : NSObject{
    BOOL flag;
}

@property (copy, nonatomic) NSData *object;
@property (copy, nonatomic) NSError *error;

- (URLReturnModel *)initWithData:(NSData *)getObject error:(NSError *)getError;
- (BOOL)getFlag;
- (NSData *)getData;
- (NSError *)getError;

@end
