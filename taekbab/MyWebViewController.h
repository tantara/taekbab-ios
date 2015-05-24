//
//  MyWebViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "GAITrackedViewController.h"
#import "CommonViewController.h"

@interface MyWebViewController : CommonViewController {
    
}

@property (nonatomic, retain) NSString *currentUrl;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)close;
- (void)refresh;

@end
