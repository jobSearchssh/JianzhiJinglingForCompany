//
//  geoModel.m
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "geoModel.h"

@implementation geoModel
-(id)initWith:(double)lon lat:(double)lat{
    self = [super init];
    if (self) {
        longitude = lon;
        latitude = lat;
    }
    return self;
}
-(double)getLon{
    return longitude;
}
-(double)getLat{
    return latitude;
}
-(NSString *)getGeoArray{
    return [NSString stringWithFormat:@"%f,%f",longitude,latitude];
}
@end
