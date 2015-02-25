//
//  CommonMacro.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#ifndef JianzhiJinglingForCompany_CommonMacro_h
#define JianzhiJinglingForCompany_CommonMacro_h

//配置NavigationCotrollor  BarColor
#define NaviBarColor [UIColor colorWithRed:0.21 green:0.23 blue:0.32 alpha:1.0]

//配置TabBarCotrollor  BarColor
#define TabBarColor [UIColor colorWithRed:0.12 green:0.33 blue:0.58 alpha:1.0]


//配置CollectionView  Layout params
#define CollectionViewMiniLineSpace 3.0f
#define CollectionViewMiniInterItemsSpace 3.0f
#define CollectionViewItemsWidth ((MainScreenWidth-(2*CollectionViewMiniInterItemsSpace))/3)

//Key_WINDOW 长宽
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width




//Alert
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]



//NSUserDefaults  中的字段
#define CURRENTUSERNAME   @"currentUserName"
#define CURRENTUSERID  @"currentUserObjectId"
#define CURRENTLOCATOIN @"currentCoordinate"
#define CURRENTLOGOURL @"currentLogoUrl"
#define CURRENTINTRODUCTION @"currentIntro"
#define CURRENTUSERREALNAME @"enterpriseName"
#define CURRENTUSERINDUSTRY @"enterpriseIndustry"
#define CURRENTUSERADDRESS @"enterpriseAddress"

#define COMPROFILEFlag  @"profileSetted"
#endif
