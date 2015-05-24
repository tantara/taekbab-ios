//
//  MyRequest.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "MyRequest.h"

#import "Agent.h"
#import "MyCache.h"

@implementation MyRequest

+ (id) requestWithURL:(NSURL *)URL {
    MyRequest *req = [super requestWithURL:URL];
    
    NSMutableURLRequest *mutableRequest = [req mutableCopy];
    [mutableRequest addValue:[Agent toString] forHTTPHeaderField:@"X-AGENT"];
#if TARGET_IPHONE_SIMULATOR
        [mutableRequest addValue:@"ios-simulator" forHTTPHeaderField:@"X-DEVICE"];
#else
        [mutableRequest addValue:[MyCache load:@"devToken"] forHTTPHeaderField:@"X-DEVICE"];
#endif

    req = [mutableRequest copy];
    
    return req;
}

@end
