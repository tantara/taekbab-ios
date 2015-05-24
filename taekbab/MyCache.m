
//
//  MyCache.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "MyCache.h"

@implementation MyCache

+ (void)save:(NSString *)key withData:(NSString *)data {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:key];
}

+ (NSString *)load:(NSString *)key {
    if([self hasKey:key]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        return [prefs objectForKey:key];
    }
    else {
        return @"";
    }
}

+ (BOOL)hasKey:(NSString *)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:key] != nil;
}

@end

