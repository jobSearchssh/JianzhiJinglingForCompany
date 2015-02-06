//
//  enterpriseDetailModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "enterpriseDetailModel.h"

@implementation enterpriseDetailModel
-(enterpriseDetailModel *)initWithDictionary:(NSDictionary *)dictinary{
    self = [super init];
    if (self) {
        enterprise_id = [dictinary objectForKey:@"enterprise_id"];
        enterpriseName = [dictinary objectForKey:@"enterpriseName"];
        enterpriseIndustry = [dictinary objectForKey:@"enterpriseIndustry"];
        enterpriseProvince = [dictinary objectForKey:@"enterpriseProvince"];
        enterpriseCity = [dictinary objectForKey:@"enterpriseCity"];
        enterpriseDistrict = [dictinary objectForKey:@"enterpriseDistrict"];
        enterpriseAddressDetail = [dictinary objectForKey:@"enterpriseAddressDetail"];
        enterpriseIntroduction = [dictinary objectForKey:@"enterpriseIntroduction"];
        NSArray *geoArray = [dictinary objectForKey:@"enterpriseGeoPoint"];
        if ([geoArray count] == 2) {
            NSNumber *lon = [geoArray objectAtIndex:0];
            NSNumber *lat = [geoArray objectAtIndex:1];
            geomodel = [[geoModel alloc]initWith:[lon doubleValue] lat:[lat doubleValue]];
        }
        enterpriseLogoURL = [dictinary objectForKey:@"enterpriseName"];
        enterpriseInviteTypes = [dictinary objectForKey:@"enterpriseName"];
    }
    return self;
}

-(NSString *)getBaseString{
    NSMutableString *baseString = [[NSMutableString alloc]initWithFormat:@"enterprise_id=%@",enterprise_id];
    
    if (enterpriseName!=Nil) {
        [baseString appendFormat:@"&enterpriseName=%@",enterpriseName];
    }
    if (enterpriseIndustry.intValue != enterpriseIndustryNIL) {
        [baseString appendFormat:@"&enterpriseIndustry=%d",enterpriseIndustry.intValue];
    }
    if (enterpriseProvince != Nil) {
        [baseString appendFormat:@"&enterpriseProvince=%@",enterpriseProvince];
    }
    if (enterpriseCity != Nil) {
        [baseString appendFormat:@"&enterpriseCity=%@",enterpriseCity];
    }
    if (enterpriseDistrict != Nil) {
        [baseString appendFormat:@"&enterpriseDistrict=%@",enterpriseDistrict];
    }
    if (enterpriseAddressDetail != Nil) {
        [baseString appendFormat:@"&enterpriseAddressDetail=%@",enterpriseAddressDetail];
    }
    if (enterpriseIntroduction != Nil) {
        [baseString appendFormat:@"&jobEnterpriseIntroduction=%@",enterpriseIntroduction];
    }
    if ([geomodel getLon] < 360 && [geomodel getLat] <360) {
        NSString *geoPoint = [NSString stringWithFormat:@"\"%f,%f\"",[geomodel getLon],[geomodel getLat]];
        [baseString appendFormat:@"&enterpriseGeoPoint=%@",geoPoint];
    }
    if (enterpriseLogoURL != Nil) {
        [baseString appendFormat:@"&enterpriseLogoURL=%@",enterpriseLogoURL];
    }
    return baseString;
}

-(NSString *)getenterprise_id{
    return enterprise_id;
}
-(void)setgetenterprise_id:(NSString *)value{
    enterprise_id = value;
}

-(NSString *)getenterpriseName{
    return enterpriseName;
}
-(void)setenterpriseName:(NSString *)value{
    enterpriseName = value;
}

-(NSNumber *)getenterpriseIndustry{
    return enterpriseIndustry;
}
-(void)setenterpriseIndustry:(NSNumber *)value{
    enterpriseIndustry = value;
}

-(NSString *)getenterpriseProvince{
    return enterpriseProvince;
}
-(void)setenterpriseProvince:(NSString *)value{
    enterpriseProvince = value;
}

-(NSString *)getenterpriseCity{
    return enterpriseCity;
}
-(void)setenterpriseCity:(NSString *)value{
    enterpriseCity = value;
}

-(NSString *)getenterpriseDistrict{
    return enterpriseDistrict;
}
-(void)setenterpriseDistrict:(NSString *)value{
    enterpriseDistrict = value;
}

-(NSString *)getenterpriseAddressDetail{
    return enterpriseAddressDetail;
}
-(void)setenterpriseAddressDetail:(NSString *)value{
    enterpriseAddressDetail = value;
}

-(NSString *)getenterpriseIntroduction{
    return enterpriseIntroduction;
}
-(void)setenterpriseIntroduction:(NSString *)value{
    enterpriseIntroduction = value;
}

-(NSString *)getenterpriseLogoURL{
    return enterpriseLogoURL;
}
-(void)setenterpriseLogoURL:(NSString *)value{
    enterpriseLogoURL = value;
}

-(NSString *)getenterpriseInviteTypes{
    return enterpriseInviteTypes;
}
-(void)setenterpriseInviteTypes:(NSString *)value{
    enterpriseInviteTypes = value;
}

-(geoModel *)getGeo{
    return geomodel;
}
-(void)setgeoModel:(geoModel *)value{
    geomodel = value;
}

@end
