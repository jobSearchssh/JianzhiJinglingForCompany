//
//  jobModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseJobModel.h"
#import "DateUtil.h"

@interface jobModel : baseJobModel{
    NSString *jobId;
//    NSDate *jobBirthdayMonthYear;
    NSDate *jobBeginTime;
    NSDate *jobEndTime;
    NSArray *jobWorkTime;
    NSArray *jobWorkPlaceGeoPoint;
    NSString *jobWorkPlaceProvince;
    NSString *jobWorkPlaceCity;
    NSString *jobWorkPlaceDistrict;
    NSString *jobWorkAddressDetail;
    NSString *jobTitle;
    NSNumber *jobRecruitNum;
    NSArray *jobType;
    NSNumber *jobSalaryRange;
    NSString *jobSettlementWay;
    NSString *jobIntroduction;
    NSString *jobAgeStartReq;
    NSString *jobAgeEndReq;
    NSString *jobHeightStartReq;
    NSString *jobHeightEndReq;
    NSString *jobEnterpriseName;
    NSString *jobEnterpriseIndustry;
    NSString *jobEnterpriseAddress;
    NSString *jobEnterpriseIntroduction;
    NSString *jobDegreeReq;
    NSString *jobPhone;
//    NSString *jobEmail;
    NSDate *created_at;
    NSString *jobContactName;
    NSString *jobEnterpriseImageURL;
    NSString *jobEnterpriseLogoURL;
    NSDate * updated_at;
    NSNumber *jobHasAccepted;
    NSNumber *jobHasRejected;
}

-(jobModel *)initWithDictionary:(NSDictionary *)initDictionary;
//-(NSDate *)getjobBirthdayMonthYear;
-(NSDate *)getjobBeginTime;
-(NSDate *)getjobEndTime;
-(NSDate *)getcreated_at;
-(NSArray *)getjobWorkTime;
-(NSArray *)getjobWorkPlaceGeoPoint;
-(NSArray *)getjobType;
-(NSNumber *)getjobRecruitNum;
-(NSNumber *)getjobSalaryRange;
-(NSString *)getjobWorkPlaceProvince;
-(NSString *)getjobWorkPlaceCity;
-(NSString *)getjobWorkPlaceDistrict;
-(NSString *)getjobWorkAddressDetail;
-(NSString *)getjobTitle;
-(NSString *)getjobSettlementWay;
-(NSString *)getjobIntroduction;
-(NSString *)getjobAgeStartReq;
-(NSString *)getjobAgeEndReq;
-(NSString *)getjobHeightStartReq;
-(NSString *)getjobHeightEndReq;
-(NSString *)getjobEnterpriseName;
-(NSString *)getjobEnterpriseIndustry;
-(NSString *)getjobEnterpriseAddress;
-(NSString *)getjobEnterpriseIntroduction;
-(NSString *)getjobDegreeReq;
-(NSString *)getjobPhone;
//-(NSString *)getjobEmail;
-(NSString *)getjobID;
-(NSString *)getjobContactName;
-(NSString *)getjobEnterpriseImageURL;
-(NSString *)getjobEnterpriseLogoURL;
-(NSDate *)getupdated_at;
-(NSNumber*)getjobHasAccepted;
-(NSNumber*)getjobHasRejected;

+ (float)getDistance:(NSArray*)p1;

@end
