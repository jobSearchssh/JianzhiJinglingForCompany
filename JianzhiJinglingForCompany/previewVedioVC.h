//
//  previewVedioVC.h
//  jobSearch
//
//  Created by 田原 on 15/2/28.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioSession.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

#import "geturlProtocol.h"

#define upload 0
#define preview 1

@interface previewVedioVC : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) NSString *vedioPath;
@property (strong, nonatomic) NSNumber *type;
//回调协议
@property (assign, nonatomic) NSObject<getVideoURLDelegate> *setVideoURLDelegate;
@end
