//
//  FourthViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 19..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

#import "CommonViewController.h"

@interface FourthViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>

// for table
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *tableData;
@property (nonatomic, strong) NSArray *tableHeaders;

@end
