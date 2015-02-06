//
//  jobModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "createJobModel.h"

@implementation createJobModel
-(id)init{
    self = [super init];
    if (self) {
        for (int index = 0; index < ITEMNUMBER; index++) {
            isOK[index] = false;
            jobWorkTime = [[NSArray alloc]init];
        }
    }
    return self;
}
-(int)getIsOK{
    int result = -1;
    for (int index = 0; index < ITEMNUMBER; index++) {
        if (!isOK[index]) {
            result = index;
        }
    }
    return result;
}
-(NSString *)getWorkTimeArray{
    NSMutableString *getArray = [[NSMutableString alloc]initWithFormat:@"\""];
    for (int index = 0; index < [jobWorkTime count] ; index++ ) {
        NSNumber *number = [jobWorkTime objectAtIndex:index];
        [getArray appendFormat:@"%d",number.intValue];
        if (index != ([jobWorkTime count] -1)) {
            [getArray appendFormat:@","];
        }
    }
    [getArray appendFormat:@"\""];
    return getArray;
}

-(NSString *)notOKResult:(int)number{
    NSString *res = Nil;
    switch (number) {
        case DATAOK:
            res = @"数据完整";
            break;
        case 0:
            res = @"第0号数据未填写";
            break;
        case 1:
            res = @"第1号数据未填写";
            break;
        case 2:
            res = @"第2号数据未填写";
            break;
        case 3:
            res = @"第3号数据未填写";
            break;
        case 4:
            res = @"第4号数据未填写";
            break;
        case 5:
            res = @"第5号数据未填写";
            break;
        case 6:
            res = @"第6号数据未填写";
            break;
        case 7:
            res = @"第7号数据未填写";
            break;
        case 8:
            res = @"第8号数据未填写";
            break;
        case 9:
            res = @"第9号数据未填写";
            break;
        case 10:
            res = @"第10号数据未填写";
            break;
        case 11:
            res = @"第11号数据未填写";
            break;
        case 12:
            res = @"第12号数据未填写";
            break;
        case 13:
            res = @"第13号数据未填写";
            break;
        case 14:
            res = @"第14号数据未填写";
            break;
        case 15:
            res = @"第15号数据未填写";
            break;
        case 16:
            res = @"第16号数据未填写";
            break;
        case 17:
            res = @"第17号数据未填写";
            break;
        case 18:
            res = @"第18号数据未填写";
            break;
        case 19:
            res = @"第19号数据未填写";
            break;
        case 20:
            res = @"第20号数据未填写";
            break;
        case 21:
            res = @"第21号数据未填写";
            break;
        case 22:
            res = @"第22号数据未填写";
            break;
        case 23:
            res = @"第23号数据未填写";
            break;
        case 24:
            res = @"第24号数据未填写";
            break;
        case 25:
            res = @"第25号数据未填写";
            break;
        case 26:
            res = @"第26号数据未填写";
            break;
        case 27:
            res = @"第27号数据未填写";
            break;
        case 28:
            res = @"第28号数据未填写";
            break;
        default:
            res = @"未定义错误";
            break;
    }
    return res;
}

-(void)setenterprise_id:(NSString *)_id{
    enterprise_id = _id;
    isOK[0] = TRUE;
}
-(void)setjobBeginTime:(NSDate *)beginTime{
    jobBeginTime = beginTime;
    isOK[1] = TRUE;
}
-(void)setjobEndTime:(NSDate *)endTime{
    jobEndTime = endTime;
    isOK[2] = TRUE;
}
-(void)setjobGenderReq:(int)req{
    jobGenderReq = req;
    isOK[3] = TRUE;
}
-(void)setgeomodel:(geoModel *)geo{
    geomodel = geo;
    isOK[4] = TRUE;
}
-(void)setjobWorkProvince:(NSString *)province{
    jobWorkProvince = province;
    isOK[5] = TRUE;
}
-(void)setjobWorkCity:(NSString *)city{
    jobWorkCity = city;
    isOK[6] = TRUE;
}
-(void)setjobWorkDistrict:(NSString *)district{
    jobWorkDistrict = district;
    isOK[7] = TRUE;
}
-(void)setjobWorkTime:(NSArray *)array{
    jobWorkTime = array;
    isOK[8] = TRUE;
}
-(void)setjobWorkAddressDetail:(NSString *)addressDetail{
    jobWorkAddressDetail = addressDetail;
    isOK[9] = TRUE;
}
-(void)setjobTitle:(NSString *)title{
    jobTitle = title;
    isOK[10] = TRUE;
}
-(void)setjobType:(int)type{
    jobType = type;
    isOK[11] = TRUE;
}
-(void)setjobSalary:(int)salary{
    jobSalary = salary;
    isOK[12] = TRUE;
}
-(void)setjobSettlementWay:(int)settlementWay{
    jobSettlementWay = settlementWay;
    isOK[13] = TRUE;
}
-(void)setjobDegreeReq:(int)req{
    jobDegreeReq = req;
    isOK[14] = TRUE;
}
-(void)setjobAgeStartReq:(int)req{
    jobAgeStartReq = req;
    isOK[15] = TRUE;
}
-(void)setjobAgeEndReq:(int)req{
    jobAgeEndReq = req;
    isOK[16] = TRUE;
}
-(void)setjobHeightStartReq:(int)req{
    jobHeightStartReq = req;
    isOK[17] = TRUE;
}
-(void)setjobHeightEndReq:(int)req{
    jobHeightEndReq = req;
    isOK[18] = TRUE;
}
-(void)setjobEnterpriseName:(NSString *)name{
    jobEnterpriseName = name;
    isOK[19] = TRUE;
}
-(void)setjobEnterpriseAddress:(NSString *)address{
    jobEnterpriseAddress = address;
    isOK[20] = TRUE;
}
-(void)setjobContactPhone:(NSString *)phone{
    jobContactPhone = phone;
    isOK[21] = TRUE;
}
-(void)setjobContactName:(NSString *)name{
    jobContactName = name;
    isOK[22] = TRUE;
}
-(void)setjobEnterpriseIntroduction:(NSString *)introduction{
    jobEnterpriseIntroduction = introduction;
    isOK[23] = TRUE;
}
-(void)setjobEnterpriseImageURL:(NSString *)url{
    jobEnterpriseImageURL = url;
    isOK[24] = TRUE;
}
-(void)setjobEnterpriseLogoURL:(NSString *)url{
    jobEnterpriseLogoURL = url;
    isOK[25] = TRUE;
}
-(void)setjobRecruitNum:(int)num{
    jobRecruitNum = num;
    isOK[26] = TRUE;
}
-(void)setjobEnterpriseIndustry:(int)industry{
    jobEnterpriseIndustry = industry;
    isOK[27] = TRUE;
}
-(void)setjobIntroduction:(NSString *)introduction{
    jobIntroduction = introduction;
    isOK[28] = TRUE;
}
-(NSString *)getBaseString{
    NSMutableString *baseString = [[NSMutableString alloc]initWithFormat:@"enterprise_id=%@",enterprise_id];
    [baseString appendFormat:@"&jobBeginTime=%@",[DateUtil startTimeStringFromDate:jobBeginTime]];
    [baseString appendFormat:@"&jobEndTime=%@",[DateUtil startTimeStringFromDate:jobEndTime]];
    [baseString appendFormat:@"&jobGenderReq=%d",jobGenderReq];
    [baseString appendFormat:@"&jobWorkPlaceGeoPoint=%@",[geomodel getGeoArray]];
    [baseString appendFormat:@"&jobWorkProvince=%@",jobWorkProvince];
    [baseString appendFormat:@"&jobWorkTime=%@",[self getWorkTimeArray]];
    [baseString appendFormat:@"&jobWorkCity=%@",jobWorkCity];
    [baseString appendFormat:@"&jobWorkDistrict=%@",jobWorkDistrict];
    [baseString appendFormat:@"&jobWorkAddressDetail=%@",jobWorkAddressDetail];
    [baseString appendFormat:@"&jobTitle=%@",jobTitle];
    [baseString appendFormat:@"&jobIntroduction=%@",jobIntroduction];
    [baseString appendFormat:@"&jobType=%d",jobType];
    [baseString appendFormat:@"&jobSalary=%d",jobSalary];
    [baseString appendFormat:@"&jobSettlementWay=%d",jobSettlementWay];
    [baseString appendFormat:@"&jobDegreeReq=%d",jobDegreeReq];
    [baseString appendFormat:@"&jobAgeStartReq=%d",jobAgeStartReq];
    [baseString appendFormat:@"&jobAgeEndReq=%d",jobAgeEndReq];
    [baseString appendFormat:@"&jobHeightStartReq=%d",jobHeightStartReq];
    [baseString appendFormat:@"&jobHeightEndReq=%d",jobHeightEndReq];
    [baseString appendFormat:@"&jobEnterpriseName=%@",jobEnterpriseName];
    [baseString appendFormat:@"&jobEnterpriseIndustry=%d",jobEnterpriseIndustry];
    [baseString appendFormat:@"&jobEnterpriseAddress=%@",jobEnterpriseAddress];
    [baseString appendFormat:@"&jobContactPhone=%@",jobContactPhone];
    [baseString appendFormat:@"&jobContactName=%@",jobContactName];
    [baseString appendFormat:@"&jobEnterpriseIntroduction=%@",jobEnterpriseIntroduction];
    [baseString appendFormat:@"&jobEnterpriseImageURL=%@",jobEnterpriseImageURL];
    [baseString appendFormat:@"&jobEnterpriseLogoURL=%@",jobEnterpriseLogoURL];
    [baseString appendFormat:@"&jobRecruitNum=%d",jobRecruitNum];
    return baseString;
}
@end
