//
//  enterpriseDetailModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "geoModel.h"

#define enterpriseIndustryNIL -1
#define lonlatNIL 1000

@interface enterpriseDetailModel : NSObject{
    NSString *enterprise_id;
    NSString *enterpriseName;
    NSNumber *enterpriseIndustry;
    NSString *enterpriseProvince;
    NSString *enterpriseCity;
    NSString *enterpriseDistrict;
    NSString *enterpriseAddressDetail;
    NSString *enterpriseIntroduction;
    geoModel *geomodel;
    NSString *enterpriseLogoURL;
    NSString *enterpriseInviteTypes;
}

-(enterpriseDetailModel *)initWithDictionary:(NSDictionary *)dictinary;

-(NSString *)getBaseString;

-(NSString *)getenterprise_id;
-(void)setgetenterprise_id:(NSString *)value;

-(NSString *)getenterpriseName;
-(void)setenterpriseName:(NSString *)value;

-(NSNumber *)getenterpriseIndustry;
-(void)setenterpriseIndustry:(NSNumber*)value;

-(NSString *)getenterpriseProvince;
-(void)setenterpriseProvince:(NSString *)value;

-(NSString *)getenterpriseCity;
-(void)setenterpriseCity:(NSString *)value;

-(NSString *)getenterpriseDistrict;
-(void)setenterpriseDistrict:(NSString *)value;

-(NSString *)getenterpriseAddressDetail;
-(void)setenterpriseAddressDetail:(NSString *)value;

-(NSString *)getenterpriseIntroduction;
-(void)setenterpriseIntroduction:(NSString *)value;

-(NSString *)getenterpriseLogoURL;
-(void)setenterpriseLogoURL:(NSString *)value;

-(NSString *)getenterpriseInviteTypes;
-(void)setenterpriseInviteTypes:(NSString *)value;

-(geoModel *)getGeo;
-(void)setgeoModel:(geoModel *)value;


@end
