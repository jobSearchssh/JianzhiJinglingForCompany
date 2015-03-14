//
//  GlobalConstant.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/9/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXTERN NSDictionary *const JobTypeDict;



@interface GlobalConstant : NSObject

+(instancetype)shareInstance;

@property (nonatomic,readonly)NSDictionary *jobTypeDict;
@property (nonatomic,readonly)NSDictionary *eduTypeDict;
@property (nonatomic,readonly)NSDictionary *payTypeDict;

@end
