//
//  FirstViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"

@interface FirstViewController : CommonViewController {
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;

@property (nonatomic, retain) NSString *currentUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setURL:(NSString*)url;
- (void)openURL:(NSString*)url;
- (IBAction)refresh:(id)sender;
- (void)loadHome;
- (IBAction)goHome:(id)sender;

@end