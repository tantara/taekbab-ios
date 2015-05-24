//
//  FirstViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

#pragma mark - webview

- (void)setURL:(NSString *)url {
    self.currentUrl = url;
}

- (void)openURL:(NSString*)url {
    if([url rangeOfString:BASE_URL].location == NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [self.webView loadRequest:[MyRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (void) loadHome {
   [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    NSString *urlString = [BASE_URL stringByAppendingString:ROOT_PATH];
    MyRequest *req = [MyRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:req];
}

- (IBAction)goHome:(id)sender {
    [self loadHome];
}

@end
