//
//  oprationResultModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"

@interface oprationResultModel : baseModel{
    NSString *datas;
}
-(oprationResultModel *)initWithData:(NSData *)mainData;
-(oprationResultModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSString *)getOprationID;
@end
