
//  AppDelegate.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "AppDelegate.h"

// lib
#import "GAI.h"
#import <Crashlytics/Crashlytics.h>

// custom module
#import "ColorUtils.h"
#import "Constant.h"
#import "MyRequest.h"
#import "MyCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-63076590-1"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // Enable IDFA collection.
    tracker.allowIDFACollection = YES;
    
    // crashlystics
    [Crashlytics startWithAPIKey:@"5767904c8cd4f389d89280de3e342eab800cdfa3"];
    
    // Add registration for remote notifications
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // color
//    UIColor * color = [UIColor colorWithRed:0/255.0f green:55/255.0f blue:129/255.0f alpha:1.0f];
//    UIColor * color = [UIColor colorWithRed:18/255.0f green:53/255.0f blue:138/255.0f alpha:1.0f];
//    UIColor * color = [UIColor colorWithRed:102/255.0f green:174/255.0f blue:228/255.0f alpha:1.0f];
    UIColor * color = [ColorUtils globalColor];
    
//    [[UIView appearance] setTintColor:color];
    [[UITabBar appearance] setTintColor:color];
//    [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor purpleColor]];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 어플 자신이 호출된 경우에 얼럿창 띄우기
//    NSString *strURL = [url absoluteString];
//    
//    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"call message"
//                                                       message:strURL
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alertView  show];
    
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    
    if([[url host] isEqualToString:@"openTab"]) {
        NSInteger index = [[dict objectForKey:@"index"] integerValue];
        UITabBarController *tabBarController = (UITabBarController*)(self.window.rootViewController);
        [tabBarController setSelectedIndex:index];
    }
    else if([[url host] isEqualToString:@"openMenu"]) {
        NSInteger tab = [[dict objectForKey:@"tab"] integerValue];
        NSNumber *menu = [dict objectForKey:@"menu"];
        UITabBarController *tabBarController = (UITabBarController*)(self.window.rootViewController);
        [tabBarController setSelectedIndex:tab];
        
        UINavigationController *navController = (UINavigationController*)tabBarController.selectedViewController;
        UIViewController *mainController = navController.viewControllers.firstObject;
        
        if ([mainController respondsToSelector:@selector(openMenu:)]) {
            [mainController performSelector:@selector(openMenu:) withObject:menu];
        }
    }
    else if([[url host] isEqualToString:@"openUrl"]) {
        NSString *url = [dict objectForKey:@"url"];
        
        NSInteger index = 0;
        UITabBarController *tabBarController = (UITabBarController*)(self.window.rootViewController);
        [tabBarController setSelectedIndex:index];
        
        UINavigationController *navController = (UINavigationController*)tabBarController.selectedViewController;
        UIViewController *mainController = [navController topViewController];
        
        if ([mainController respondsToSelector:@selector(openURL:)]) {
            [mainController performSelector:@selector(setURL:) withObject:url];
            [mainController performSelector:@selector(openURL:) withObject:url];
        }
    }
    
    return YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

# pragma mark apns

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Error in registration. Error: %@", error);
    
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Remote Notification: %@", [userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"안내", nil)
                                                            message:[apsInfo objectForKey:@"alert"]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        NSString *alert = [apsInfo objectForKey:@"alert"];
        NSLog(@"Received Push Alert: %@", alert);
        
        NSString *badge = [apsInfo objectForKey:@"badge"];
        NSLog(@"Received Push Badge: %@", badge);
        
        NSString *sound = [apsInfo objectForKey:@"sound"];
        NSLog(@"Received Push Sound: %@", sound);
        NSLog(@"userinfo: %@", userInfo);
    }
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
#endif
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
    
    if (rntypes == UIRemoteNotificationTypeBadge) {
        pushBadge = @"enabled";
    }
    
    else if (rntypes == UIRemoteNotificationTypeAlert) {
        pushAlert = @"enabled";
    }
    
    else if (rntypes == UIRemoteNotificationTypeSound) {
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)) {
        pushAlert = @"enabled";
        pushBadge = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = [[dev identifierForVendor] UUIDString];
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [MyCache save:@"devToken" withData:devToken];
    
    // Build URL String for Registration
    NSString *urlString = [[BASE_URL stringByAppendingString:REGISTER_DEVICE_PATH] stringByAppendingString:@"?type=device"];
    urlString = [urlString stringByAppendingFormat:@"&appname=%@", appName];
    urlString = [urlString stringByAppendingFormat:@"&appversion=%@", appVersion];
    urlString = [urlString stringByAppendingFormat:@"&deviceuid=%@", deviceUuid];
    urlString = [urlString stringByAppendingFormat:@"&devicetoken=%@", devToken];
    urlString = [urlString stringByAppendingFormat:@"&devicename=%@", deviceName];
    urlString = [urlString stringByAppendingFormat:@"&devicemodel=%@", deviceModel];
    urlString = [urlString stringByAppendingFormat:@"&deviceversion=%@", deviceSystemVersion];
    urlString = [urlString stringByAppendingFormat:@"&pushbadge=%@", pushBadge];
    urlString = [urlString stringByAppendingFormat:@"&pushalert=%@", pushAlert];
    urlString = [urlString stringByAppendingFormat:@"&pushsound=%@", pushSound];
    
    // Register the Device Data
    NSURL *url = [NSURL URLWithString:urlString];
    MyRequest *request = [MyRequest requestWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Register URL: %@", url);
    NSLog(@"Return Data: %@", returnData);
#endif
}


@end
