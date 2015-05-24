//
//  ThridViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 21..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "ThridViewController.h"
#import "Agent.h"
#import "Constant.h"

@interface ThridViewController ()

@end

@implementation ThridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlString = [NSString stringWithFormat:[BASE_URL stringByAppendingString:TUTORIAL_PATH]];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *mutableRequest = [req mutableCopy];
    [mutableRequest addValue:[Agent toString] forHTTPHeaderField:@"X-AGENT"];
    req = [mutableRequest copy];
    [self.webView loadRequest:req];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = NSStringFromClass([self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
