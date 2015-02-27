//
//  MLLocationServiceManager.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "geoModel.h"
@interface MLLocationServiceManager : NSObject
+(MLLocationServiceManager*)shareInstance;

-(void)startLocationServiceWithCompleteBlock:(void(^)(void))block;
-(void)startLocationServiceWithCompleteBlock:(void(^)(void))block Error:(void(^)(void))errorBlock;

//为坐标添加KVO
@property (nonatomic,readonly)geoModel *rightNowGeoPoint;
@end
