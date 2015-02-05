//
//  MLLoginBusiness.h
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol loginResult <NSObject>
@required
- (void)loginResult:(BOOL)isSucceed Feedback:(NSString*)feedback;
@end

@protocol registerResult <NSObject>
@required
- (void)registerResult:(BOOL)isSucceed Feedback:(NSString*)feedback;
@end


@interface MLLoginBusiness : NSObject

@property(nonatomic,weak) id<loginResult> loginResultDelegate;

@property(nonatomic,weak) id<registerResult> registerResultDelegate;

- (void)loginInBackground:(NSString*) username Password:(NSString*)pwd;

+ (void)logout;

- (void)registerInBackground:(NSString*)username Password:(NSString*)pwd;

@end
