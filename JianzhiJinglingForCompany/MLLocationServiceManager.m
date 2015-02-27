//
//  MLLocationServiceManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "MLLocationServiceManager.h"
#import "AJLocationManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@implementation MLLocationServiceManager


static MLLocationServiceManager* thisInstance;
+(MLLocationServiceManager*)shareInstance
{
    if (thisInstance==nil) {
        thisInstance=[[MLLocationServiceManager alloc]init];
    }
    return thisInstance;
}

-(void)startLocationServiceWithCompleteBlock:(void(^)(void))block Error:(void(^)(void))errorBlock
{
    AJLocationManager *ajLocationManager=[AJLocationManager shareLocation];
    [ajLocationManager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
         _rightNowGeoPoint=[[geoModel alloc]initWith:locationCorrrdinate.longitude lat:locationCorrrdinate.latitude];
        NSString *gpsString=[NSString stringWithFormat:@"{%f,%f}",[_rightNowGeoPoint getLon],[_rightNowGeoPoint getLat]];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:gpsString forKey:CURRENTLOCATOIN];
        [mySettingData synchronize];
        //请求数据
        block();
    } error:^(NSError *error) {
//        [MBProgressHUD showError:error toView:nil];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        if ([mySettingData objectForKey:CURRENTLOCATOIN]) {
            //用上一个地址
            NSString *locationString= [mySettingData objectForKey:CURRENTLOCATOIN];
            CGPoint point=CGPointFromString(locationString);
            _rightNowGeoPoint=[[geoModel alloc]initWith:point.x lat:point.y];
        }
        errorBlock();
        ALERT(error.description);
        //定位失败一切，位置服务相关的都停止
    }];
}


-(void)startLocationServiceWithCompleteBlock:(void(^)(void))block
{

    AJLocationManager *ajLocationManager=[AJLocationManager shareLocation];
    [ajLocationManager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
        _rightNowGeoPoint=[[geoModel alloc]initWith:locationCorrrdinate.longitude lat:locationCorrrdinate.latitude];
        NSString *gpsString=[NSString stringWithFormat:@"{%f,%f}",[_rightNowGeoPoint getLon],[_rightNowGeoPoint getLat]];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:gpsString forKey:CURRENTLOCATOIN];
        [mySettingData synchronize];
        //请求数据
        block();
    } error:^(NSError *error) {
        ALERT(error.description);
        //定位失败一切，位置服务相关的都停止
    }];


}

@end
