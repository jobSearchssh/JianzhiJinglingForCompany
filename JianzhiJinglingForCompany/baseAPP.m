//
//  baseAPP.m
//  wowilling
//
//  Created by 田原 on 14-3-5.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "baseAPP.h"

static NSOperationQueue *queue;
static NSString *usrID;
@implementation baseAPP
-(id)init{
    self = [super init];
    if(nil != self){
        @try {
            [self initData];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
    }
    return self;
}
-(void)initData{
    queue = [[NSOperationQueue alloc]init];
//    usrID = [[NSString alloc]init];
    usrID = [NSString stringWithFormat:@"54cdee5b3ed1ccf5358b458a"];
}

+(void)setUsrID:(NSString *)setUsrID{
    usrID = setUsrID;
}
+(NSString *)getUsrID{
    return usrID;
}

+(NSOperationQueue *)getBaseNSOperationQueue{
    return queue;
}


@end
