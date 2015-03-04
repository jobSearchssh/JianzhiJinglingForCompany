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
#import "badgeModel.h"
#import "iniviteModel.h"
#import "inivitesListModel.h"
@interface netAPI : NSObject

typedef void (^returnBlock)(URLReturnModel *returnModel);
typedef void (^loginReturnBlock)(loginModel *loginModel);
typedef void (^registerReturnBlock)(registerModel *registerModel);
typedef void (^createeditReturnBlock)(ceateOrEditInfoModel *createEditModel);
typedef void (^operationReturnBlock)(oprationResultModel *oprationModel);
typedef void (^enterpriseDetailReturnBlock)(enterpriseDetailReturnModel *detailModel);
typedef void (^jobListReturnBlock)(jobListModel *jobListModel);
typedef void (^userListReturnBlock)(userListModel *userListModel);

typedef void (^badgeBlock)(badgeModel *badgeModel);

typedef void (^inivitesListReturnBlock)(inivitesListModel *inivitesListModel);

#define STATIS_OK 0
#define STATIS_NO 1


//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(NSData *)getInfo getFunction:(NSString *)function block:(returnBlock)block;
//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(NSData *)postInfo getFunction:(NSString *)function block:(returnBlock)block;
//邀请者列表
+(void)queryInivitesList:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(inivitesListReturnBlock)inivitesListBlock;

//enterprise登录
//用户名，密码，回调block
+(void)enterpriseLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock;


//重置用户密码
+(void)usrResetPassword:(NSString *)name usrPassword:(NSString *)password withBlock:(operationReturnBlock)oprationReturnBlock;

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

//获取邀请列表
+(void)queryInvitedJobUsers:(NSString *)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock;


//附近的人
+(void)queryNearestUsers:(NSString *)enterprise_id start:(int)start length:(int)length lon:(double)lon lat:(double)lat withBlock:(userListReturnBlock)userListBlock;
//一定距离内的人
+(void)queryNearestUsersWithDistance:(NSString *)enterprise_id start:(int)start length:(int)length lon:(double)lon lat:(double)lat distance:(int)dis withBlock:(userListReturnBlock)userListBlock;

//申请我职位的人
+(void)getMyRecruitUsers:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock;

/**
 申请我职位的人(新接口)
**/
 +(void)getMyRecruitUsers:(NSString*)enterprise_id start:(int)start length:(int)length withType:(int)type withBlock:(userListReturnBlock)userListReturnBlock;
//创建职位模板
+(void)createJobTemplate:(createJobModel *)jobmodel withBlock:(operationReturnBlock)operationBlock;

//获取职位模板
+(void)getJobTemplate:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(jobListReturnBlock)jobListBlock;

//删除一条发布的职位
+(void)deleteTheJob:(NSString *)enterprise_id job_id:(NSString *)job_id withBlock:(operationReturnBlock)oprationReturnBlock;

//删除邀请；
+(void)cancelInvitedUser:(NSString*)enterprise_id invite_id:(NSString*)userId withBlock:(operationReturnBlock)oprationReturnBlock;

//删除一条职位模板
+(void)deleteTheJobTemplate:(NSString *)enterprise_id jobTemplate_id:(NSString *)jobTemplate_id withBlock:(operationReturnBlock)oprationReturnBlock;

//精灵匹配
+(void)getjinglingMatch:(NSString*)enterprise_id start:(int)start length:(int)length withBlock:(userListReturnBlock)userListBlock;

//取消关注
+(void)cancelFocusUser:(NSString*)enterprise_id user_id:(NSString*)userId withBlock:(operationReturnBlock)oprationReturnBlock;

//邀请求职者
+(void)inviteUserWithEnterpriseId:(NSString*)enterprise_id userId:(NSString*)userId jobId:(NSString*)jobId withBlock:(operationReturnBlock)oprationReturnBlock;

//获取未读消息数
+(void)getNotReadMessageNum:(NSString*)userId withBlock:(badgeBlock)badgeReturnBlock;
+(void)setRecordAlreadyRead:(NSString*)userId applyOrInviteId:(NSString*)applyOrInviteId type:(NSString*)type withBlock:(operationReturnBlock)oprationReturnBlock;


+(void)test;


@end
