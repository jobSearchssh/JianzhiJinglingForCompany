//
//  BadgeManager.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 2/19/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "BadgeManager.h"
#import "netAPI.h"
@implementation BadgeManager

static BadgeManager * thisObject;
+(BadgeManager*)shareSingletonInstance
{
    if (thisObject==nil) {
        thisObject=[[BadgeManager alloc]init];
    }
    return thisObject;
}

- (void)refreshCount{
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:CURRENTUSERID];
    
    if ([currentUserObjectId length]>0) {
        
        self.messageCount=[myData objectForKey:@"badgeInviteNum"];
        self.applyCount=[myData objectForKey:@"badgeApplyNum"];
        
        [netAPI getNotReadMessageNum:currentUserObjectId withBlock:^(badgeModel *badgeModel) {
            
            if ([badgeModel.getStatus intValue]==0) {
                self.messageCount=[NSString stringWithFormat:@"%@",badgeModel.getinviteNotRead];
                self.applyCount=[NSString stringWithFormat:@"%@",badgeModel.getapplyNotRead];
                
                [myData setObject:self.messageCount forKey:@"badgeInviteNum"];
                [myData setObject:self.applyCount forKey:@"badgeApplyNum"];
                [myData synchronize];
            }
        }];
    }
}

- (void)minusMessageCount{
    if ([self.messageCount intValue]>=1) {
        self.messageCount=[NSString stringWithFormat:@"%d",[self.messageCount intValue]-1];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:self.messageCount forKey:@"badgeInviteNum"];
        [mySettingData synchronize];
    }
}

- (void)minusApplyCount{
    if ([self.applyCount intValue]>=1) {
        self.applyCount=[NSString stringWithFormat:@"%d",[self.applyCount intValue]-1];
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:self.messageCount forKey:@"badgeApplyNum"];
        [mySettingData synchronize];
    }
    
}

-(void)performBadgeNumChangesInBackGround
{

    
    
    
}


@end
