//
//  ceateOrEditInfoModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "baseModel.h"

@interface ceateOrEditInfoModel : baseModel{
    NSString *datas;
}
-(ceateOrEditInfoModel *)initWithData:(NSData *)mainData;
-(ceateOrEditInfoModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSString *)getEnterpriseID;

@end
