//
//  SecondViewController.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"

@interface SecondViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource>

// for table
@property (nonatomic, strong) NSMutableDictionary *dataJson;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) updateUI:(NSDictionary*) json;
- (IBAction)refresh:(id)sender;

@end

