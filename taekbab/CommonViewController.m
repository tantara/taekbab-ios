//
//  CommonViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "CommonViewController.h"

// custom module
#import "Agent.h"
#import "ColorUtils.h"
#import "Constant.h"
#import "MyRequest.h"
#import "MyCache.h"

#import "MyWebViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // GA configuration
    self.screenName = NSStringFromClass([self class]);
}

#pragma mark - receive push

- (void)openMenu:(NSNumber*)menu {
    // nothing
}

#pragma mark - webview

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    BOOL headerIsPresent = [[request allHTTPHeaderFields] objectForKey:@"X-AGENT"]!=nil;
    
    if(headerIsPresent) return YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [request URL];
//            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            MyRequest *request = [MyRequest requestWithURL:url];
            
//            // set the new headers
//            for(NSString *key in [webView.customHeaders allKeys]){
//                [request addValue:[webView.customHeaders objectForKey:key] forHTTPHeaderField:key];
//            }
            
            // reload the request
            [webView loadRequest:request];
        });
    });
    return NO;
}

-(void)webViewDidStartLoad:(UIWebView*)webView
{
    // ProgressBar Setting
    if(!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self.activityIndicator setCenter:webView.center];
        [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview : self.activityIndicator];
    }
    
    // ProgressBar Start
    self.activityIndicator.hidden= NO;
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden= YES;
}

@end
