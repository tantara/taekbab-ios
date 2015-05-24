//
//  FirstViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FirstViewController : GAITrackedViewController<UIWebViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *currentUrl;

- (void)openURL:(NSString*)url;
- (void)setURL:(NSString*)url;
- (IBAction)refresh:(id)sender;
- (IBAction)goHome:(id)sender;


@end

