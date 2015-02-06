//
//  jobsModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "jobModel.h"

@interface jobListModel : baseModel{
    NSMutableArray *savejobsArray;
}

-(jobListModel *)initWithData:(NSData *)mainData;
-(jobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getJobArray;
@end
