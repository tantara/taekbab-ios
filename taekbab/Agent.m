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
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    UIDevice *div = [UIDevice currentDevice];
    NSString *deviceModel = div.model;
    NSString *deviceSystemVersion = div.systemVersion;
    
    agent = [NSString stringWithFormat:@"%@ %@, %@", deviceModel, deviceSystemVersion, appVersion];
    
    return agent;
}

@end
