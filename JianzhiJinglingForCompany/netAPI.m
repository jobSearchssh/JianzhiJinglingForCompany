//
//  netAPI.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "netAPI.h"
//login&register
#define LOGIN_FUNCTION @"enterprise/enterpriseLogin"
#define REGISTER_FUNCTION @"enterprise/enterpriseRegister"
#define CREATEOREDITINFO_FUNCTION @"enterprise/editEnterpriseDetail"
#define CEATEJOB_FUNCTION @"enterprise/createJob"
#define ACCEPTJOBAPPLY_FUNCTION @"enterprise/acceptJobApply"
#define REJECTJOBAYYLY_FUNCTION @"enterprise/refuseJobApply"
#define STARJOBER_FUNCTION @"enterprise/starJobUser"
#define GETENTERPRISEDETAIL_FUNCTION @"enterprise/getEnterpriseDetail"
#define queryEnterpriseJobs_FUNCTION @"enterpriseService/queryEnterpriseJobs"

#define queryInvitedJobUsers_FUNCTION @"enterpriseService/queryInivitesList"
#define queryStarJobUsers_FUNCTINON @"enterpriseService/queryStarJobUsers"
#define queryNearestUsers_FUNCTINON @"enterpriseService/queryNearestUsers"
#define queryUsersByDistance_FUNCTINON @"enterpriseService/queryUsersByDistance"
#define getMyRecruitUsers_FUNCTINON @"enterpriseService/queryRecieveJobList"
#define createJobTemplate_FUNCTINON @"enterprise/createJobTemplate"
#define getJobTemplate_FUNCTINON @"enterprise/getJobTemplateList"
#define deleteOneJob_FUNCTINON @"enterprise/deleteOneJob"
#define deleteOneJobTemplate @"enterprise/deleteOneJobTemplate"
#define cancelInvitedUser_FUNCTION @"enterprise/deleteOneInvite"
#define cancelStarUser @"enterprise/cancelStarUser"
#define jinglingMatch @"enterpriseService/queryJingLingList"
#define INVITEUSER_FUNCTION @"enterprise/addEnterpriseInvite"


#define Multi_INVITEUSERMulti_FUNCTION @"enterprise/addManyEnterpriseInvite"
#define GETBADGENUM_FUNCTION @"enterprise/enterpriseNumIsNotRead"
#define SETREAD_FUNCTION @"enterprise/enterpriseIsRead"

#define queryInivitesList_function @"enterpriseService/queryInivitesList"

#define networkError @"请查看网络连接是否正常"
@implementation netAPI
+(void)test{
//    //测试ok
//    [netAPI enterpriseLogin:@"17801034920" usrPassword:@"1234" withBlock:^(loginModel *loginModel) {
//        NSLog(@"usrLogin id = %@",[loginModel getUsrID]);
//    }];
    
    
    
//    //测试ok
//    [netAPI enterpriseRegister:@"17801&034920" usrPassword:@"1234" withBlock:^(registerModel *registerModel) {
//        NSLog(@"usrRegister id = %@",[registerModel getUsrID]);
//    }];
    
    
    
    
//    //测试ok
//    enterpriseDetailModel *detail = [[enterpriseDetailModel alloc] init];
//    [detail setgetenterprise_id:@"54d85c5296d9aeca6f8b456e"];
//    [detail setenterpriseName:@"百度"];
//    [detail setenterpriseIndustry:[NSNumber numberWithInt:2]];
//    [detail setenterpriseProvince:@"北京"];
//    [detail setenterpriseCity:@"海淀区"];
//    [detail setenterpriseDistrict:@"西二旗"];
//    [detail setenterpriseAddressDetail:@"真的找不到啊!"];
//    [detail setenterpriseIntroduction:@"真是简单可依赖"];
//    [detail setgeoModel:[[geoModel alloc]initWith:45.67 lat:23.45]];
//    [detail setenterpriseLogoURL:@"qwerty"];
//    [netAPI createOrEditEnterpriseInfo:detail withBlock:^(ceateOrEditInfoModel *createEditModel) {
//        NSLog(@"status = %d info = %@ Enterprise id = %@",[createEditModel getStatus].intValue,[createEditModel getInfo],[createEditModel getEnterpriseID]);
//    }];
    
    
    //新建job 测试ok
    //下面所有项不能为空
//    createJobModel *newJob = [[createJobModel alloc]init];
//    [newJob setenterprise_id:@"54d82f0096d9aeaa708b456a"];
//    [newJob setjobBeginTime:[NSDate date]];
//    [newJob setjobEndTime:[NSDate date]];
//    [newJob setjobGenderReq:1];
//    geoModel *geo = [[geoModel alloc]initWith:23.45 lat:56.78];
//    [newJob setgeomodel:geo];
//    [newJob setjobWorkProvince:@"北京"];
//    [newJob setjobWorkCity:@"海淀"];
//    [newJob setjobWorkDistrict:@"西土城路"];
//    [newJob setjobWorkTime:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:3], nil]];
//    [newJob setjobWorkAddressDetail:@"北京市海淀区西土城路10号"];
//    [newJob setjobTitle:@"北京邮电大学招聘"];
//    [newJob setjobIntroduction:@"北邮科技大厦每天扫地"];
//    [newJob setjobType:0];
//    [newJob setjobSalary:100];
//    [newJob setjobSettlementWay:0];
//    [newJob setjobDegreeReq:1];
//    [newJob setjobAgeStartReq:22];
//    [newJob setjobAgeEndReq:32];
//    [newJob setjobHeightStartReq:168];
//    [newJob setjobHeightEndReq:178];
//    [newJob setjobEnterpriseName:@"北邮"];
//    [newJob setjobEnterpriseIndustry:2];
//    [newJob setjobEnterpriseAddress:@"西土城路10号"];
//    [newJob setjobContactName:@"田原"];
//    [newJob setjobContactPhone:@"186107822215"];
//    [newJob setjobEnterpriseIntroduction:@"北邮啊"];
//    [newJob setjobEnterpriseImageURL:@"a"];
//    [newJob setjobEnterpriseLogoURL:@"b"];
//    [newJob setjobRecruitNum:12];
//    NSLog(@"%@",[newJob getBaseString]);
//    [netAPI createJob:newJob withBlock:^(oprationResultModel *oprationModel) {
//        NSLog(@"新建job id = %@",[oprationModel getOprationID]);
//    }];
//    
    
//    //接受兼职申请 测试ok
//    [netAPI acceptJobApply:@"54d3919296d9aeeb5a8b457f" withBlock:^(oprationResultModel *oprationModel) {
//        NSLog(@"acceptJobApply info = %@",[oprationModel getInfo]);
//    }];
    
//    //拒绝兼职申请 测试ok
//    [netAPI refuseJobApply:@"54d3919296d9aeeb5a8b457f" withBlock:^(oprationResultModel *oprationModel) {
//        NSLog(@"refuseJobApply info = %@",[oprationModel getInfo]);
//    }];
    
//    //starjober 测试ok
//    [netAPI starJobUser:@"54d77c2196d9aecb6f8b4569" jobUserID:@"54d76bd496d9aece6f8b4568" withBlock:^(oprationResultModel *oprationModel) {
//        NSLog(@"starJobUser info = %@",[oprationModel getInfo]);
//    }];
    
//    //获取企业详情 OK
//    [netAPI getEnterpriseDetail:@"54d85c5296d9aeca6f8b456e" withBlock:^(enterpriseDetailReturnModel *detailModel) {
//        NSLog(@"enterpriseName = %@",[[detailModel getenterpriseDetailModel] getenterpriseName]);
//    }];
    
//    //发布的列表 ok
//    [netAPI queryEnterpriseJobs:@"54d82f0096d9aeaa708b456a" start:1 length:10 withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobID]);
//        }
//    }];
    
//    //关注的人 ok
//    [netAPI queryStarJobUsers:@"54d77c2196d9aecb6f8b4569" start:1 length:10 withBlock:^(userListModel *userListModel) {
//        NSLog(@"queryStarJobUsers info = %@",[userListModel getInfo]);
//        NSMutableArray *userList = [userListModel getuserArray];
//        for (userModel *user in userList) {
//            NSLog(@"queryStarJobUsers user name =%@",[user getuserName]);
//        }
//    }];
    
//    //附近的人 ok
//    [netAPI queryNearestUsers:@"54d77c2196d9aecb6f8b4569" start:1 length:2 lon:-70.9300376 lat:42.8583925 withBlock:^(userListModel *userListModel) {
//        NSLog(@"queryNearestUsers info = %@",[userListModel getInfo]);
//        NSMutableArray *userList = [userListModel getuserArray];
//        for (userModel *user in userList) {
//            NSLog(@"queryNearestUsers user name =%@",[user getuserName]);
//        }
//    }];
}



//enterprise登录
+(void)enterpriseLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            loginModel *a = [[loginModel alloc]initWithData:[returnModel getData]];
            loginBlock(a);
        }else{
            loginModel *a = [[loginModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError usrID:[NSString stringWithFormat:@"-1"]];
            loginBlock(a);
        }
        
    }];
}

//重置用户密码
+(void)usrResetPassword:(NSString *)name usrPassword:(NSString *)password withBlock:(operationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@&type=%@",name,password,@"1"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}


//enterprise注册
+(void)enterpriseRegister:(NSString *)name usrPassword:(NSString *)password withBlock:(registerReturnBlock)registerBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:REGISTER_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            registerModel *a = [[registerModel alloc]initWithData:[returnModel getData]];
            registerBlock(a);
        }else{
            registerModel *a = [[registerModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError usrID:[NSString stringWithFormat:@"-1"]];
            registerBlock(a);
        }
    }];
}

//新建工作
+(void)createJob:(createJobModel *)jobmodel withBlock:(operationReturnBlock)operationBlock{
    NSData *data = [[jobmodel getBaseString] dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:CEATEJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            operationBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            operationBlock(a);
        }
    }];
}

//获取企业信息
+(void)getEnterpriseDetail:(NSString *)enterpriseid withBlock:(enterpriseDetailReturnBlock)rBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@",enterpriseid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:GETENTERPRISEDETAIL_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            enterpriseDetailReturnModel *a = [[enterpriseDetailReturnModel alloc]initWithData:[returnModel getData]];
            rBlock(a);
        }else{
            enterpriseDetailReturnModel *a = [[enterpriseDetailReturnModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            rBlock(a);
        }
    }];
}

//enterprise编辑信息
+(void)createOrEditEnterpriseInfo:(enterpriseDetailModel *)detail withBlock:(createeditReturnBlock)rBlock{
    NSData *data = [[detail getBaseString] dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:CREATEOREDITINFO_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            ceateOrEditInfoModel *a = [[ceateOrEditInfoModel alloc]initWithData:[returnModel getData]];
            rBlock(a);
        }else{
            ceateOrEditInfoModel *a = [[ceateOrEditInfoModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            rBlock(a);
        }
    }];
}

//接受兼职申请
+(void)acceptJobApply:(NSString *)applyID withBlock:(operationReturnBlock)operationBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"apply_id=%@",applyID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:ACCEPTJOBAPPLY_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            operationBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            operationBlock(a);
        }
    }];
}

//拒绝兼职申请
+(void)refuseJobApply:(NSString *)applyID withBlock:(operationReturnBlock)operationBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"apply_id=%@",applyID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:REJECTJOBAYYLY_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            operationBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            operationBlock(a);
        }
    }];
}

//对用户添加关注
+(void)starJobUser:(NSString *)enterpriseID jobUserID:(NSString *)usrID withBlock:(operationReturnBlock)operationBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&job_user_id=%@",enterpriseID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:STARJOBER_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            operationBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            operationBlock(a);
        }
    }];
}

//获取发布的兼职列表
+(void)queryEnterpriseJobs:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(jobListReturnBlock)jobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:queryEnterpriseJobs_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            NSLog(@"result:%@",returnModel );
            jobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            jobListBlock(a);
        }
    }];
}

//获取邀请列表
+(void)queryInvitedJobUsers:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock
{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:queryInvitedJobUsers_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListBlock(a);
        }
    }];
}

//关注人列表
+(void)queryStarJobUsers:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:queryStarJobUsers_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListBlock(a);
        }
    }];
}
//一定距离范围的人
+(void)queryNearestUsersWithDistance:(NSString *)enterprise_id start:(int)start length:(int)length lon:(double)lon lat:(double)lat distance:(int)dis withBlock:(userListReturnBlock)userListBlock
{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&lon=%f&lat=%f&distance=%d",enterprise_id,start,length,lon,lat,dis];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:queryUsersByDistance_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListBlock(a);
        }
    }];
}

//附近的人
+(void)queryNearestUsers:(NSString *)enterprise_id start:(int)start length:(int)length lon:(double)lon lat:(double)lat withBlock:(userListReturnBlock)userListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&lon=%f&lat=%f",enterprise_id,start,length,lon,lat];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:queryNearestUsers_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListBlock(a);
        }
    }];
}


//申请我职位的人
+(void)getMyRecruitUsers:(NSString*)enterprise_id start:(int)start length:(int)length withType:(int)type withBlock:(userListReturnBlock)userListReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&type=%d&",enterprise_id,start,length,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:getMyRecruitUsers_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListReturnBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListReturnBlock(a);
        }
    }];
}




//申请我职位的人
+(void)getMyRecruitUsers:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:getMyRecruitUsers_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListReturnBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListReturnBlock(a);
        }
    }];
}

//新建工作模板
+(void)createJobTemplate:(createJobModel *)jobmodel withBlock:(operationReturnBlock)operationBlock{
    NSData *data = [[jobmodel getBaseString] dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:createJobTemplate_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            operationBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            operationBlock(a);
        }
    }];
}

+(void)getJobTemplate:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(jobListReturnBlock)jobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:getJobTemplate_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            //NSLog(@"result:%@",returnModel );
            jobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            jobListBlock(a);
        }
    }];
}
//删除一条发布的职位
+(void)deleteTheJob:(NSString *)enterprise_id job_id:(NSString *)job_id withBlock:(operationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&job_id=%@",enterprise_id,job_id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:deleteOneJob_FUNCTINON block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}
//删除一条职位模板
+(void)deleteTheJobTemplate:(NSString *)enterprise_id jobTemplate_id:(NSString *)jobTemplate_id withBlock:(operationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&jobTemplate_id=%@",enterprise_id,jobTemplate_id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:deleteOneJobTemplate block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}


//取消邀请
+(void)cancelInvitedUser:(NSString*)enterprise_id invite_id:(NSString*)userId withBlock:(operationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&invite_id=%@",enterprise_id,userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:cancelInvitedUser_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

+(void)cancelFocusUser:(NSString*)enterprise_id user_id:(NSString*)userId withBlock:(operationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&job_user_id=%@",enterprise_id,userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:cancelStarUser block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

+(void)getjinglingMatch:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self testAPIPostTestWithBlock:data getFunction:jinglingMatch block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userListModel *a = [[userListModel alloc]initWithData:[returnModel getData]];
            userListBlock(a);
        }else{
            userListModel *a = [[userListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userListBlock(a);
        }

    }];
}

//邀请多个求职者
+(void)inviteUserWithEnterpriseId:(NSString*)enterprise_id userId:(NSString*)userId jobId:(NSString*)jobId withBlock:(operationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&job_user_id=%@&job_id=%@",enterprise_id,userId,jobId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:INVITEUSER_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//邀请求职者
+(void)MultiInviteUserWithEnterpriseId:(NSString*)enterprise_id userId:(NSString*)userId jobId:(NSString*)jobId withBlock:(operationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&job_user_id=%@&job_id=%@",enterprise_id,userId,jobId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:Multi_INVITEUSERMulti_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}
//queryInivitesList
+(void)queryInivitesList:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(inivitesListReturnBlock)inivitesListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&start=%d&length=%d&",enterprise_id,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self testAPIPostTestWithBlock:data getFunction:queryInivitesList_function block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            inivitesListModel *a = [[inivitesListModel alloc]initWithData:[returnModel getData]];
            inivitesListBlock(a);
        }else{
            inivitesListModel *a = [[inivitesListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            inivitesListBlock(a);
        }
        
    }];
}



//获取未读消息数
+(void)getNotReadMessageNum:(NSString*)userId withBlock:(badgeBlock)badgeReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@",userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:GETBADGENUM_FUNCTION block:^(URLReturnModel *returnModel) {
        
        if (returnModel != Nil && [returnModel getFlag]) {
            badgeModel *a = [[badgeModel alloc]initWithData:[returnModel getData]];
            badgeReturnBlock(a);
        }else{
            badgeModel *a =[[badgeModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            badgeReturnBlock(a);
        }
    }];
}

//标记未读消息为已读
+(void)setRecordAlreadyRead:(NSString*)userId applyOrInviteId:(NSString*)applyOrInviteId type:(NSString*)type withBlock:(operationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"enterprise_id=%@&applyOrInviteId=%@&type=%@",userId,applyOrInviteId,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:SETREAD_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}



#pragma base API


//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(NSData *)getInfo getFunction:(NSString *)function block:(returnBlock)block{
    @try {
        URLOperationWithBlock *operation = [[URLOperationWithBlock alloc]initWithURL:getInfo serveceFunction:function returnblock:block isPost:FALSE];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(NSData *)postInfo getFunction:(NSString *)function block:(returnBlock)block{
    @try {
        URLOperationWithBlock *operation = [[URLOperationWithBlock alloc]initWithURL:postInfo serveceFunction:function returnblock:block isPost:TRUE];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}

@end
