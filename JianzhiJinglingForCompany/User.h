//
//  User.h
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString* userObjectId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userEmail;
@property (nonatomic, strong) NSString* userPhone;
@property (nonatomic, strong) NSString* userPassword;
@property (nonatomic, strong) NSNumber* userType;


+ (User *)getCurrentUser;



@end
