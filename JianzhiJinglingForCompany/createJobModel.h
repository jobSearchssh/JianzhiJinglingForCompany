//
//  jobModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "geoModel.h"
#import "DateUtil.h"
#define ITEMNUMBER 29
#define DATAOK -1

@interface createJobModel : NSObject{
    NSString *enterprise_id;
    NSDate *jobBeginTime;
    NSDate *jobEndTime;
    int jobGenderReq;
    geoModel *geomodel;
    NSString *jobWorkProvince;
    NSString *jobWorkCity;
    NSString *jobWorkDistrict;
    NSArray *jobWorkTime;
    NSString *jobWorkAddressDetail;
    NSString *jobTitle;
    NSString *jobIntroduction;
    int jobType;
    int jobSalary;
    int jobSettlementWay;
    int jobDegreeReq;
    int jobAgeStartReq;
    int jobAgeEndReq;
    int jobHeightStartReq;
    int jobHeightEndReq;
    NSString* jobEnterpriseName;
    NSString *jobEnterpriseAddress;
    NSString *jobContactPhone;
    NSString *jobContactName;
    NSString *jobEnterpriseIntroduction;
    NSString *jobEnterpriseImageURL;
    NSString *jobEnterpriseLogoURL;
    int jobRecruitNum;
    int jobEnterpriseIndustry;
    
    
    BOOL isOK[ITEMNUMBER];
}
//get方法











//原始方法
-(id)init;
-(int)getIsOK;
-(NSString *)notOKResult:(int)number;
-(NSString *)getWorkTimeArray;

-(void)setenterprise_id:(NSString *)_id;
-(void)setjobBeginTime:(NSDate *)beginTime;
-(void)setjobEndTime:(NSDate *)endTime;
-(void)setjobGenderReq:(int)req;
-(void)setgeomodel:(geoModel *)geo;
-(void)setjobWorkProvince:(NSString *)province;
-(void)setjobWorkCity:(NSString *)city;
-(void)setjobWorkDistrict:(NSString *)district;
-(void)setjobWorkTime:(NSArray *)array;
-(void)setjobWorkAddressDetail:(NSString *)addressDetail;
-(void)setjobTitle:(NSString *)title;
-(void)setjobType:(int)type;
-(void)setjobSalary:(int)salary;
-(void)setjobSettlementWay:(int)settlementWay;
-(void)setjobDegreeReq:(int)req;
-(void)setjobAgeStartReq:(int)req;
-(void)setjobAgeEndReq:(int)req;
-(void)setjobHeightStartReq:(int)req;
-(void)setjobHeightEndReq:(int)req;
-(void)setjobEnterpriseName:(NSString *)name;
-(void)setjobEnterpriseAddress:(NSString *)address;
-(void)setjobContactPhone:(NSString *)phone;
-(void)setjobContactName:(NSString *)name;
-(void)setjobEnterpriseIntroduction:(NSString *)introduction;
-(void)setjobEnterpriseImageURL:(NSString *)url;
-(void)setjobEnterpriseLogoURL:(NSString *)url;
-(void)setjobRecruitNum:(int)num;
-(void)setjobEnterpriseIndustry:(int)industry;
-(void)setjobIntroduction:(NSString *)introduction;
-(NSString *)getBaseString;
@end
