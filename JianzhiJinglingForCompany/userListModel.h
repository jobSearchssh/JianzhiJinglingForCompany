//
//  userListModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "baseModel.h"
#import "userModel.h"

@interface userListModel : baseModel{
    NSMutableArray *userList;
}

-(userListModel *)initWithData:(NSData *)mainData;
-(userListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getuserArray;
@end
