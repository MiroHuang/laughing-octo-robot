//
//  AppDelegate.m
//  test_background
//
//  Created by 黄凯 on 16/10/21.
//  Copyright © 2016年 HuangKai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, assign) BOOL backgroundActive;
@property (nonatomic, assign) UIBackgroundTaskIdentifier background_task;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationBackgrountHandler:(UIApplication *)application {
    if (self.background_task == UIBackgroundTaskInvalid) {
        self.background_task = [application beginBackgroundTaskWithExpirationHandler:nil];
        
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while(1) {
                if (!weakSelf.backgroundActive) {
                    [application endBackgroundTask:weakSelf.background_task];
                    weakSelf.background_task = UIBackgroundTaskInvalid;
                    break;
                }
                //编写执行任务代码
                NSLog(@"%@", [NSDate date]);
                sleep(1);
            }
        });
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.backgroundActive = YES;
    [self applicationBackgrountHandler:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    self.backgroundActive = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
