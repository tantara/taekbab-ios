//
//  CommonViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

// lib
#import "GAITrackedViewController.h"

// custom module
#import "Agent.h"
#import "ColorUtils.h"
#import "Constant.h"
#import "MyRequest.h"
#import "MyCache.h"

@interface CommonViewController : GAITrackedViewController<UIWebViewDelegate>

// webview
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)openMenu:(NSNumber*)menu;

@end
