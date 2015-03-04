//
//  InivitesListModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/3/3.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "baseModel.h"
#import "iniviteModel.h"

@interface inivitesListModel : baseModel{
    NSMutableArray *inivitesArray;
}

-(inivitesListModel *)initWithData:(NSData *)mainData;
-(inivitesListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getinivitesArray;

@end
