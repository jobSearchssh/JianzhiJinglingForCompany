//
//  PageSplitingManager.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageSplitingManager : NSObject
{
   NSUInteger  nextStartAt;
}

/****
  页码，也即分页次数,初始值为1
***/
@property (nonatomic) NSUInteger pagination;
/**
 页长，每页大小
 **/
@property (nonatomic) NSUInteger pageSize;

@property (nonatomic,readonly)NSUInteger firstStartIndex;

-(PageSplitingManager*)initWithPageSize:(NSUInteger)size;

/**
 功能：重置分页管理器
 说明：pagination 设为初始值
**/
-(BOOL)resetPageSplitingManager;


/**
 功能：获取下一个start值
 **/

-(NSUInteger)getNextStartAt;


/**
 功能：完成分页加载
 **/
-(BOOL)pageLoadCompleted;


/**
 功能：页码+1
 **/

-(NSUInteger)addOnePage;


/**
 功能：页码-1
 **/
-(NSUInteger)minusOnePage;

@end
