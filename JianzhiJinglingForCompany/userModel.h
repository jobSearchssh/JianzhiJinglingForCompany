//
//  userModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/7.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "geoModel.h"
#import "baseModel.h"
#import "DateUtil.h"

#define STATIS_OK 0
#define STATIS_NO 1

@interface userModel : baseModel{
    NSString *job_user_id;
    NSString *userName;
    NSNumber *userGender;
    NSDate *userBirthday;
    NSString *userProvince;
    NSString *userDistrict;
    NSString *userCity;
    NSString *userAddressDetail;
    NSString *userSchool;
    NSNumber *userDegree;
    NSMutableArray *userHopeJobType;
    NSMutableArray *userFreeTime;
    NSMutableArray *userHopeSettlement;
    NSString *userIntroduction;
    NSString *userExperience;
    NSString *userPhone;
    NSString *userEmail;
    NSNumber *userInfoComplete;
    NSString *userVideoURL;
    geoModel *userLocationGeo;
    NSString *beiyong1;
    NSString *beiyong2;
    NSString *beiyong3;
    NSNumber *beiyong4;
    NSMutableArray *ImageFileURL;
    NSNumber *userHeight;
    NSString *userIdentityCardNum;
    
    NSString *applyStatus;
    NSString *apply_id;
    
    NSDate *updateAt;
    NSDate *createAt;
    
    //新增标记已读未读字段;
    NSString *enterpriseInviteIsRead;
    NSString *invite_id;
}

-(userModel *)initWithData:(NSData *)mainData;
-(userModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(userModel *)initWithDictionary:(NSDictionary *)initDictionary;

-(NSString *)getBaseString;


-(NSString *)getjob_user_id;
-(void)setjob_user_id:(NSString *)value;

-(NSString *)getuserName;
-(void)setuserName:(NSString *)value;

-(NSDate *)getuserBirthday;
-(void)setuserBirthday:(NSDate *)value;

-(NSString *)getuserProvince;
-(void)setuserProvince:(NSString *)value;

-(NSString *)getuserDistrict;
-(void)setuserDistrict:(NSString *)value;

-(NSString *)getuserCity;
-(void)setuserCity:(NSString *)value;

-(NSString *)getuserAddressDetail;
-(void)setuserAddressDetail:(NSString *)value;

-(NSString *)getuserSchool;
-(void)setuserSchool:(NSString *)value;

-(NSString *)getuserIntroduction;
-(void)setuserIntroduction:(NSString *)value;

-(NSString *)getuserExperience;
-(void)setuserExperience:(NSString *)value;

-(NSString *)getuserPhone;
-(void)setuserPhone:(NSString *)value;

-(NSString *)getuserEmail;
-(void)setuserEmail:(NSString *)value;

-(NSString *)getuserVideoURL;
-(void)setuserVideoURL:(NSString *)value;

-(NSString *)getbeiyong1;
-(void)setbeiyong1:(NSString *)value;

-(NSString *)getbeiyong2;
-(void)setbeiyong2:(NSString *)value;

-(NSString *)getbeiyong3;
-(void)setbeiyong3:(NSString *)value;

-(NSNumber *)getuserGender;
-(void)setuserGender:(NSNumber *)value;

-(NSNumber *)getuserDegree;
-(void)setuserDegree:(NSNumber *)value;

-(NSMutableArray *)getuserHopeJobType;
-(void)setuserHopeJobType:(NSMutableArray *)value;

-(NSMutableArray *)getuserFreeTime;
-(void)setuserFreeTime:(NSMutableArray *)value;


-(NSMutableArray *)getuserHopeSettlement;
-(void)setuserHopeSettlement:(NSMutableArray *)value;

-(geoModel *)getuserLocationGeo;
-(void)setuserLocationGeo:(geoModel *)value;

-(NSMutableArray *)getImageFileURL;
-(void)setImageFileURL:(NSMutableArray *)value;


-(NSNumber *)getuserHeight;
-(void)setuserHeight:(NSNumber *)value;

-(NSString*)getuserIdentityCardNum;
-(void)setuserIdentityCardNum:(NSString*)num;


-(NSString *)getEnterpriseInviteIsRead;
-(NSString *)getInvite_id;




-(NSString*)getApplyStatus;

-(NSString*)getApply_id;

-(NSDate*)getUpdateAt;

-(NSDate*)getCreateAt;


+ (float)getDistance:(NSArray*)p1;
@end
