//
//  PageSplitingManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "PageSplitingManager.h"


/**
 下一次请求的Start;
 **/
@implementation PageSplitingManager
//初始化
-(PageSplitingManager*)initWithPageSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        _pageSize=size;
        _pagination=0;
        _firstStartIndex=1;
    }
    return self;
}

-(NSUInteger)getNextStartAt
{
    nextStartAt=self.pagination*self.pageSize+1;
    return nextStartAt;
}
/**
 功能：重置分页管理器
 说明：pagination 设为初始值
 **/
-(BOOL)resetPageSplitingManager
{
    self.pagination=0;
    return YES;
}


/**
 功能：完成分页加载
 **/

-(BOOL)pageLoadCompleted
{
    [self addOnePage];
    return YES;
}

/**
 功能：页码+1
 **/

-(NSUInteger)addOnePage
{
    self.pagination+=1;
    return self.pagination;
}

-(NSUInteger)minusOnePage
{
    if (self.pagination>0) {
        self.pagination-=1;
    }
    return self.pagination;
}





@end
