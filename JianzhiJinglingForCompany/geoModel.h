//
//  geoModel.h
//  JianzhiJinglingForCompany
//
//  Created by 田原 on 15/2/6.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface geoModel : NSObject{
    double longitude;
    double latitude;
}

-(id)initWith:(double)lon lat:(double)lat;
-(double)getLon;
-(double)getLat;
-(NSString *)getGeoArray;
@end
