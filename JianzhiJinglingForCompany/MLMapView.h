//
//  MLMapView.h
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MLMapView : UIView<MAMapViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, retain) MAMapView *mapView;
@end
