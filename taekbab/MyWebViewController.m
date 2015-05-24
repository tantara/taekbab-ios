//
//  MyWebViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    [closeButton setStyle:UIBarButtonItemStyleDone];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
        [refreshButton setStyle:UIBarButtonItemStyleDone];
    
    self.navigationItem.leftBarButtonItem = closeButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.webView loadRequest:[MyRequest requestWithURL:[NSURL URLWithString:self.currentUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
     NSString *titleTag = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = titleTag;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {
    [self.webView reload];
}

@end
