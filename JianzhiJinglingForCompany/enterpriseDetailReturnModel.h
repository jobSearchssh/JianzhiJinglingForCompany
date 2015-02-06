//
//  enterpriseDetailModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "baseModel.h"
#import "enterpriseDetailModel.h"

@interface enterpriseDetailReturnModel : baseModel{
    enterpriseDetailModel *detail;
}
-(enterpriseDetailReturnModel *)initWithData:(NSData *)mainData;
-(enterpriseDetailReturnModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(enterpriseDetailModel *)getenterpriseDetailModel;
@end
