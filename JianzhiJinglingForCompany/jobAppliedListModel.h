//
//  jobAppliedListModel.h
//  jobSearch
//
//  Created by RAY on 15/2/12.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "jobAppliedModel.h"


@interface jobAppliedListModel : baseModel
{
     NSMutableArray *jobAppliedArray;
}

-(jobAppliedListModel *)initWithData:(NSData *)mainData;
-(jobAppliedListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getjobAppliedArray;

@end
