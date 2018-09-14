//
//  AppDelegate.m
//  GGame1
//
//  Created by Fsy on 2018/9/6.
//  Copyright © 2018年 Fsy. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <UserNotifications/UserNotifications.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    
    [UMConfigure initWithAppkey:nil channel:@"App Store"];
    
    
    // Push's basic setting
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
    
    return YES;
}



//获取测试的token

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"测试：%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""]);
}


// 收到友盟的消息推送
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler

{
    
    NSLog(@"===didReceiveRemoteNotification===");
    
    // 注意：当应用处在前台的时候，是不会弹出通知的，这个时候就需要自己进行处理弹出一个通知的UI
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"] message:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                              
                                                       delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    
    else if (application.applicationState == UIApplicationStateInactive){
        
        //......
        
    }
    
    // 这个是友盟自带的前台弹出框
    
    [UMessage setAutoAlert:NO];
    
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    
}

//iOS10新增：处理前台收到通知的代理方法

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"===willPresentNotification1===");
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于前台时的远程推送接受
        
        //关闭U-Push自带的弹出框
        
        [UMessage setAutoAlert:NO];
        
        //必须加这句代码
        
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSLog(@"===willPresentNotification2===");
        
    }else{
        
        //应用处于前台时的本地推送接受
        
        NSLog(@"===willPresentNotification3===");
        
    }
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
#ifdef UM_Swift
        
        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
        
#else
        NSLog(@"===didReceiveNotificationResponse===");
        
        [UMessage didReceiveRemoteNotification:userInfo];
#endif
        
    }else{
        
        //应用处于后台时的本地推送接受
    }
}




//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//}
//
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//}
//
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}


@end
