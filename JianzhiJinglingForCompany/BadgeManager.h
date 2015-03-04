//
//  BadgeManager.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/19/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeManager : NSObject

@property (nonatomic) NSString *messageCount;
@property (nonatomic) NSString *applyCount;

+(BadgeManager*)shareSingletonInstance;
- (void)refreshCount;
- (void)minusApplyCount;
- (void)minusMessageCount;
@end
