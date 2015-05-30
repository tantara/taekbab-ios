//
//  TodayViewController.h
//  widget
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@interface TodayViewController : GAITrackedViewController<NSURLSessionDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegment;
@property (weak, nonatomic) IBOutlet UIButton *goToAppButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) loadData;
- (void) updateUI:(NSDictionary*)data;
- (IBAction)refresh:(id)sender;
- (IBAction)timeChanged:(id)sender;
- (IBAction)goToApp:(id)sender;
- (IBAction)openMsg:(id)sender;

@end
