//
//  URLOperationWithBlock.m
//  TestAPI
//
//  Created by 田原 on 15/1/28.
//  Copyright (c) 2015年 田原. All rights reserved.
//

#import "URLOperationWithBlock.h"
static NSString *baseURL = @"http://123.57.5.113:8081/";

@implementation URLOperationWithBlock
//data为post数据 postFunction为post地址 block为回调函数
- (id)initWithURL:(NSData*)getInfo serveceFunction:(NSString *)getPostLoca returnblock:(returnBlock)rblock isPost:(BOOL)postOrGet{
    self = [super init];
    if (self) {
        postInfo = getInfo;
        postLoca = getPostLoca;
        isPost = postOrGet;
        block =rblock;
    }
    return self;
}

- (void)main{
    
    @try {
        //添加自动释放池，控制内存峰值 效果待验证 by gyb 
        @autoreleasepool {
       
        //第一步，生成链接地址
        NSURL *url = [NSURL URLWithString:[[NSString alloc]initWithFormat:@"%@%@",baseURL,postLoca]];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
        
        if (isPost) {
            [request setHTTPMethod:@"POST"];
        }else{
            [request setHTTPMethod:@"GET"];
        }
        if (postInfo != Nil) {
            [request setHTTPBody:postInfo];
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            URLReturnModel *objRe = [[URLReturnModel alloc]initWithData:data error:error];
//            NSLog(@"data:%@",data);
            if (block != Nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(objRe);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(Nil);
                });
            }
        }];
        
        [task resume];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"网络错误");
    }
}

@end
