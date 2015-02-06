//
//  URLOperationWithBlock.h
//  TestAPI
//
//  Created by 田原 on 15/1/28.
//  Copyright (c) 2015年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLReturnModel.h"

typedef void (^returnBlock)(URLReturnModel *returnModel);
@interface URLOperationWithBlock : NSOperation{
    NSData *postInfo;
    NSString *postLoca;
    BOOL isPost;
    returnBlock block;
}
//data为post数据 postFunction为post地址 block为回调函数
- (id)initWithURL:(NSData*)getInfo serveceFunction:(NSString *)getPostLoca returnblock:(returnBlock)rblock isPost:(BOOL)postOrGet;
@end
