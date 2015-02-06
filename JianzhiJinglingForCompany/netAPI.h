//
//  netAPI.h
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLOperationWithBlock.h"
#import "baseAPP.h"
#import "URLReturnModel.h"
#import "loginModel.h"
#import "registerModel.h"
#import "ceateOrEditInfoModel.h"
#import "createJobModel.h"
#import "oprationResultModel.h"
#import "enterpriseDetailReturnModel.h"
#import "jobListModel.h"
#import "userListModel.h"

@interface netAPI : NSObject

typedef void (^returnBlock)(URLReturnModel *returnModel);
typedef void (^loginReturnBlock)(loginModel *loginModel);
typedef void (^registerReturnBlock)(registerModel *registerModel);
typedef void (^createeditReturnBlock)(ceateOrEditInfoModel *createEditModel);
typedef void (^operationReturnBlock)(oprationResultModel *oprationModel);
typedef void (^enterpriseDetailReturnBlock)(enterpriseDetailReturnModel *detailModel);
typedef void (^jobListReturnBlock)(jobListModel *jobListModel);
typedef void (^userListReturnBlock)(userListModel *userListModel);

#define STATIS_OK 0
#define STATIS_NO 1


//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(NSData *)getInfo getFunction:(NSString *)function block:(returnBlock)block;
//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(NSData *)postInfo getFunction:(NSString *)function block:(returnBlock)block;


//enterprise登录
//用户名，密码，回调block
+(void)enterpriseLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock;

//enterprise注册
//用户名，密码，回调block
+(void)enterpriseRegister:(NSString *)name usrPassword:(NSString *)password withBlock:(registerReturnBlock)registerBlock;

//enterprise编辑信息
+(void)createOrEditEnterpriseInfo:(enterpriseDetailModel *)detail withBlock:(createeditReturnBlock)rBlock;

//获取企业信息
+(void)getEnterpriseDetail:(NSString *)enterpriseid withBlock:(enterpriseDetailReturnBlock)rBlock;

//新建工作
+(void)createJob:(createJobModel *)jobmodel withBlock:(operationReturnBlock)operationBlock;

//接受兼职申请
+(void)acceptJobApply:(NSString *)applyID withBlock:(operationReturnBlock)operationBlock;

//拒绝兼职申请
+(void)refuseJobApply:(NSString *)applyID withBlock:(operationReturnBlock)operationBlock;

//对用户添加关注
+(void)starJobUser:(NSString *)enterpriseID jobUserID:(NSString *)usrID withBlock:(operationReturnBlock)operationBlock;

//获取发布的兼职列表
+(void)queryEnterpriseJobs:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(jobListReturnBlock)jobListBlock;

//关注人列表
+(void)queryStarJobUsers:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock;

+(void)test;

@end
