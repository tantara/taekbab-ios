//
//  FirstViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "Agent.h"
#import "Constant.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webView.delegate = self;
    if(self.currentUrl) {
        [self openURL:self.currentUrl];
    } else {
        [self loadHome];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = NSStringFromClass([self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setURL:(NSString *)url {
    self.currentUrl = url;
}

- (void)openURL:(NSString*)url {
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
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

- (void) loadHome {
   [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    NSString *urlString = [BASE_URL stringByAppendingString:ROOT_PATH];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *mutableRequest = [req mutableCopy];
    [mutableRequest addValue:[Agent toString] forHTTPHeaderField:@"X-AGENT"];
    req = [mutableRequest copy];
    [self.webView loadRequest:req];
}

- (IBAction)goHome:(id)sender {
    [self loadHome];
}

@end
