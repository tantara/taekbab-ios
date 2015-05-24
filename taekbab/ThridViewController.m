//
//  ThridViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 21..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "ThridViewController.h"

@interface ThridViewController ()

@end

@implementation ThridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlString = [NSString stringWithFormat:[BASE_URL stringByAppendingString:TUTORIAL_PATH]];
    MyRequest *req = [MyRequest requestWithURL:[NSURL URLWithString:urlString]];
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

- (void) openMenu:(NSNumber *)menu {
    [super openMenu:menu];

    if([menu intValue] == 0) {
        [self performSegueWithIdentifier: @"showSetting" sender: self];
    }
}

@end
