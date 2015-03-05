//
//  AppDelegate.m
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MobClick.h"
#import "Reachability.h"
#import <BmobSDK/Bmob.h>
#import "MLLoginBusiness.h"
#import "SMS_SDK/SMS_SDK.h"
#import "MainTabBarViewController.h"
#import "MLNaviViewController.h"
#import "UMFeedback.h"
#import "baseAPP.h"
#import "netAPI.h"
#import "BadgeManager.h"
#import "MLIntroduceVC.h"
#import "fileUtil.h"
@interface AppDelegate ()
{
    int currentConnectType;
}
@property (strong,nonatomic,readonly)MainTabBarViewController *mainTabberVC;

@property (strong, nonatomic) Reachability *internetReachability;
@property (nonatomic) BOOL isReachable;
@property (nonatomic) BOOL beenReachable;

@end
@implementation AppDelegate
@synthesize mainTabberVC=_mainTabberVC;

-(MainTabBarViewController *)mainTabberVC
{
    if (_mainTabberVC==nil) {
        _mainTabberVC=[MainTabBarViewController shareInstance];
    }
    return _mainTabberVC;
}

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化键盘控制
    
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    // Override point for customization after application launch.
    //判断是否呈现引导页
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if((![[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"])||![[[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]){
        self.window.rootViewController = [[MLIntroduceVC alloc] init];
    }
    else{
        self.window.rootViewController =self.mainTabberVC;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //基础网络初始化baseAPP
    //初始化base信息
    id base = [[baseAPP alloc]init];
    if (base == [NSNull null]) {
        NSLog(@"baseAPP初始化失败");
    }
    [netAPI test];
    
    
    //友盟
    [MobClick startWithAppkey:@"54e344c6fd98c56d32000210" reportPolicy:BATCH  channelId:nil];
    [MobClick checkUpdate:@"兼职精灵企业版有新版本啦" cancelButtonTitle:@"无情的忽略" otherButtonTitles:@"前往下载"];
    [UMFeedback setAppkey:@"54e344c6fd98c56d32000210"];
    //Bmob后台服务
    [Bmob registerWithAppKey:@"feda8b57c5da4a0364a3406906f77e2d"];
    
    //短信验证模块
    [SMS_SDK registerApp:@"57cd980818a9" withSecret:@"3bf26f5a30d5c3317f17887c4ee4986d"];
    
    
    //网络连接监测
    self.isReachable=YES;
    self.beenReachable=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    //开始监听，会启动一个run loop
    [self.internetReachability startNotifier];
    
    //刷新badge
    [[BadgeManager shareSingletonInstance] refreshCount];
    
//    //创建缓存文件夹
//    [fileUtil createPicFolder];
    return YES;
}


-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [curReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    
    if(status == NotReachable)
    {
        currentConnectType = NotReachable;
        if (self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = NO;
        }
        return;
    }
    if (status==ReachableViaWiFi) {
          currentConnectType = ReachableViaWiFi;
        if (!self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接恢复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = YES;
        }
    }
    if (status==ReachableViaWWAN) {
        currentConnectType = ReachableViaWWAN;
        if (!self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接恢复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = YES;
        }
    }

}

-(int)getCurrentConnectType{
    return currentConnectType;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
