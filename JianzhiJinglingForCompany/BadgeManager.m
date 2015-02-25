//
//  BadgeManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/19/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "BadgeManager.h"

@implementation BadgeManager

static BadgeManager * thisObject;
+(BadgeManager*)shareSingletonInstance
{
    if (thisObject==nil) {
        thisObject=[[BadgeManager alloc]init];
    }
    return thisObject;
}





@end
