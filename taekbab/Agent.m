//
//  Agent.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 18..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "Agent.h"
#import <UIKit/UIKit.h>

@implementation Agent

+ (NSString *)toString {
    NSString *agent = @"";
    
    NSString *appVersion = [self currentAppVersion];
    UIDevice *div = [UIDevice currentDevice];
    NSString *deviceModel = div.model;
    NSString *deviceSystemVersion = div.systemVersion;
    
    agent = [NSString stringWithFormat:@"%@ %@, %@", deviceModel, deviceSystemVersion, appVersion];
    
    return agent;
}

+ (NSString *)currentAppVersion {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    return appVersion;
}

+ (NSString *)currentBuildVersion {
    NSString *buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    return buildVersion;
}

@end
