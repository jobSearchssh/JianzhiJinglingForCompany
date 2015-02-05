//
//  DropDownChooseProtocol.h
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DropDownChooseDelegate <NSObject>

@optional

-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index row:(NSInteger)row;

@end

@protocol DropDownChooseDataSource <NSObject>
-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsOfPart1InSection:(NSInteger)section;
-(NSInteger)numberOfRowsOfPart2InSection:(NSInteger)section Row:(NSInteger)row;
-(NSString *)titleOfPart1InSection:(NSInteger)section index:(NSInteger) index;
-(NSString *)titleOfPart2InSection:(NSInteger)section index:(NSInteger) index row:(NSInteger)row;
-(NSInteger)defaultShowSection:(NSInteger)section;

@end



