//
//  GlobalConstant.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 3/9/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "GlobalConstant.h"


@implementation GlobalConstant
@synthesize jobTypeDict=_jobTypeDict;

-(instancetype)jobTypeDict
{
    if (_jobTypeDict==nil) {
        _jobTypeDict=@{@"模特/礼仪":@"0", @"促销/导购":@"1", @"销售":@"2" ,@"传单派发":@"3" ,@"安保":@"4" ,@"钟点工":@"5", @"法律事务":@"6", @"服务员":@"7" ,@"婚庆":@"8", @"配送/快递":@"9", @"化妆":@"10", @"护工/保姆":@"11", @"演出":@"12", @"问卷调查":@"13", @"志愿者":@"14" ,@"网络营销":@"15" ,@"导游":@"16", @"游戏代练":@"17", @"家教":@"18", @"软件/网站开发":@"19", @"会计":@"20", @"平面设计/制作":@"21", @"翻译":@"22", @"装修":@"23", @"影视制作":@"24", @"搬家":@"25", @"其他":@"26"};
    }
    return _jobTypeDict;
}

@end
