//
//  TodayViewController.m
//  widget
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Foundation/NSJSONSerialization.h>

#import "Restaurant.h"
#import "Menu.h"
#import "BuildingConfig.h"
#import "Agent.h"
#import "Constant.h"

typedef void (^MenuInfoCompletion)(BOOL newData, NSDictionary *json, NSError *err);

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSDictionary *json;
@property (assign, nonatomic) BOOL dataLoaded;
@property (assign, nonatomic) NSString* url;

@end

@implementation TodayViewController

//for iPhone:
//float maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 126;
//for iPad:
//
//float maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 171;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"view did load");
    
//    CGRect frame = self.view.frame;
//    frame.size.height = 120;
//    self.view.frame = frame;
    
//    CGRect frame = self.view.superview.frame;
//    frame.size.width = CGRectGetWidth(frame) + CGRectGetMinX(frame);
//    frame.origin.x = 0;
//    self.view.superview.frame = frame;

//    CGRect viewFrame = self.view.frame;
//    viewFrame.size.width = frame.size.width;
//    viewFrame.origin.x = 0;
//    self.view.frame = viewFrame;
    
    if(self.goToAppButton.hidden == NO || self.noticeLabel.hidden == NO) {
//        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 120);
    }
    
    self.preferredContentSize = CGSizeMake(0, 120);

    [self showTitleLabel:[self oldJson]];
    [self changeSegment];
    [self loadData];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

//- (void) viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    NSLog(@"view did appear");
//    //
//    //    if(globalJson) {
//    //        [self updateUI:globalJson];
//    //    }
//
//    //    [NSOperationQueue mainQueue];
//
//    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"me.tantara.taekbab"];
//    NSDictionary *json = [shared valueForKey:@"json"];
//    //    NSLog(@"%@",json);
//    if(json) {
//        [self updateUI:json];
//    }
//
//    if(!json) {
//        [self loadData];
//    }
//    else {
//        NSDictionary *currentDate = [json objectForKey:@"current_date"];
//        NSString *oldDate = [NSString stringWithFormat:@"%@월 %@일", [currentDate objectForKey:@"month"], [currentDate objectForKey:@"day"]];
//
//        NSDate *date = [NSDate date];
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
//
//        int year = [components year];
//        int month = [components month];
//        int day = [components day];
//
//        NSString *newDate = [NSString stringWithFormat:@"%d월 %d일", month, day];
//
//        if( ! [oldDate isEqualToString:newDate]) {
//            [self loadData];
//        }
//    }
//}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    NSLog(@"view will appear");
    
    CGRect frame = self.view.superview.frame;
    frame.size.width = CGRectGetWidth(frame) + CGRectGetMinX(frame);
    frame.origin.x = 0;
//    CGRectMake(0,CGRectGetMinY(frame), CGRectGetWidth(frame) + CGRectGetMinX(frame), CGRectGetHeight(self.view.frame));
    self.view.superview.frame = frame;
//    self.view.frame = frame;
////    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 120);
    
    [self fetchDataWithCompletion:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //    [self setPreferredContentSize:CGSizeMake(kMyFlightWidgetWidth, kMyFlightWidgetHeightWhenNotCheckedIn)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Fetch

- (void)fetchDataWithCompletion:(MenuInfoCompletion)completion
{
    //Preset dummy info
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    static NSDictionary *json;
    json = [shared valueForKey:@"json"];
    NSLog(@"%@",json);
    
    if(!json) {
        if(![self oldJson]) {
            self.dateLabel.text = @"초기화중...";
            [self loadData];
        }
        return;
    }
    
    //Simulate asynchronous fetch
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Update data
        self.json = json;
        self.dataLoaded = YES;
        
        //Call completion on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                if(json) {
                    completion(YES, json, nil);
                }
                else {
                    completion(NO, json, nil);
                }
            }
        });
    });
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    if (!self.dataLoaded)
    {
        //Start fetch
        [self fetchDataWithCompletion:^(BOOL newData, NSDictionary *json, NSError *err) {
            //            [self.aiLoading stopAnimating];
            if (err) //An error occured - make sure to notify the OS
            {
                completionHandler(NCUpdateResultFailed);
            }
            else if (newData) //New data is available - update UI and notify OS there's new data
            {
                [self updateUI:json];
                completionHandler(NCUpdateResultNewData);
            }
            else //Nothing new - no data to update
            {
                completionHandler(NCUpdateResultNoData);
            }
        }];
    }
    else
    {
        //refresh for next time and force refresh
        [self fetchDataWithCompletion:nil];
        self.dataLoaded = NO;
        
        //update UI
        [self updateUI:self.json];
        
        //The data fetched is not new, make sure to notify the OS
        completionHandler(NCUpdateResultNoData);
    }
}

- (NSDictionary*) oldJson{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    NSDictionary *json = [shared valueForKey:@"json"];
    return json;
}

// 밥 api 요청
- (void) loadData {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:API_PATH]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *mutableRequest = [req mutableCopy];
    [mutableRequest addValue:[Agent toString] forHTTPHeaderField:@"X-AGENT"];
    req = [mutableRequest copy];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    //    [self.aiLoading startAnimating];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //            NSLog(@"%@", json);
            
            NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
            [shared setObject:json forKey:@"json"];
            [shared synchronize];
            
            [self fetchDataWithCompletion:^(BOOL newData, NSDictionary *json, NSError *err) {
                //                [self.aiLoading stopAnimating];
                if (newData)
                {
                    [self updateUI:json];
                }
            }];
        }
    }];
}

- (void) clear
{
    for(UIView *view in [self.view subviews]) {
        if([view isKindOfClass:[Restaurant class]]) {
            [view removeFromSuperview];
        }
        
        if([view isKindOfClass:[Menu class]]) {
            [view removeFromSuperview];
        }
    }
}

// 뷰 업데이트
- (void) showTitleLabel:(NSDictionary*) data {
    NSDictionary *msg = [data objectForKey:@"message"];
    NSString *content = [msg objectForKey:@"content"];
    NSString *pressed = [msg objectForKey:@"pressed"];
    NSString *url = [msg objectForKey:@"url"];
    if(content && [content length] > 0) {
//        self.titleLabel.hidden = YES;
//        self.msgButton.hidden = NO;
        
        [self.msgButton setTitle:content forState:UIControlStateNormal];
        [self.msgButton setTitle:pressed forState:UIControlStateHighlighted];
        self.url = url;
    } else {
//        self.titleLabel.hidden = NO;
//        self.msgButton.hidden = YES;
    }
}

- (void) updateMenu:(NSDictionary*)data {
    NSDictionary *allMenu = [data objectForKey:@"menu"];
    NSDictionary *time;
    switch(self.timeSegment.selectedSegmentIndex) {
        case 0:
            time = [allMenu objectForKey:@"morning"];
            break;
        case 1:
            time = [allMenu objectForKey:@"lunch"];
            break;
        case 2:
            time = [allMenu objectForKey:@"dinner"];
            break;
    }
    
    [self clear];
    
    [self showTitleLabel:data];
    
    CGRect mainRect = [[UIScreen mainScreen] applicationFrame];
    
    int totalHeight = 75;
    BOOL foundBookmark = NO;
    BOOL foundMenu = NO;
    for(NSDictionary *building in time) {
        NSString *buildingNum = [building objectForKey:@"building"];
        NSString *buildingCode = [building objectForKey:@"code"];
        
        NSLog(@"code: %@", buildingCode);
        if([BuildingConfig isChecked:buildingCode]) {
            foundBookmark = YES;
            
            for(NSDictionary *restaurant in [building objectForKey:@"restaurants"]) {
                NSArray *menus = [restaurant objectForKey:@"menu_list"];
                
                if([menus count] == 0) {
                    break;
                }
                foundMenu = YES;
                
                NSString *restaurantName = [restaurant objectForKey:@"name"];
                Restaurant *restaurantView = [Restaurant customView:mainRect];
                [restaurantView setName:[NSString stringWithFormat:@"%@", buildingNum]];
                
                CGRect rFrame = restaurantView.frame;
                rFrame.origin.y = totalHeight;
                totalHeight += rFrame.size.height;
                restaurantView.frame = rFrame;
                
                if(totalHeight > [[ UIScreen mainScreen ] bounds ].size.height - 126) break;
                [self.view addSubview:restaurantView];
                
                for(NSDictionary *menu in menus) {
                    NSString *menuName = [menu objectForKey:@"menu"];
                    NSString *menuPrice = [menu objectForKey:@"price"];
                    
                    Menu *menuView = [Menu customView:mainRect];
                    [menuView setName:menuName];
                    [menuView setPrice:menuPrice];
                    
                    CGRect cFrame = menuView.frame;
                    cFrame.origin.y = totalHeight;
                    totalHeight += cFrame.size.height;
                    menuView.frame = cFrame;
                    
                    if(totalHeight > [[ UIScreen mainScreen ] bounds ].size.height - 126) break;
                    [self.view addSubview:menuView];
                }
            }
        }
    }
    
//    CGRect frame = self.view.frame;
//    frame.size.height = totalHeight;
//    self.view.frame = frame;
//    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, totalHeight);
    self.preferredContentSize = CGSizeMake(0, totalHeight);
//    self.view.superview.frame = frame;
    
    if([BuildingConfig isInitialized]) {
        self.goToAppButton.hidden = YES;
        self.noticeLabel.hidden = foundMenu;
    }
    else {
        self.goToAppButton.hidden = NO;
        self.noticeLabel.hidden = YES;
    }
    
    if(self.goToAppButton.hidden == NO || self.noticeLabel.hidden == NO) {
//        CGRect frame = self.view.frame;
//        frame.size.height = 120;
//        self.view.frame = frame;
//        self.view.superview.frame = frame;
        self.preferredContentSize = CGSizeMake(0, 120);
    }
}

//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (void) updateUI:(NSDictionary *)data {
    if(!data) {
        self.dateLabel.text = @"로딩중...";
        return;
    }
    
    self.refreshButton.hidden = NO;
    self.updateLabel.hidden = NO;
    
    NSDictionary *currentDate = [data objectForKey:@"current_date"];
    
    NSString *today = [NSString stringWithFormat:@"%@월 %@일", [currentDate objectForKey:@"month"], [currentDate objectForKey:@"day"]];
    NSLog(@"date %@", today);
    self.dateLabel.text = today;
    
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *updateTime = [NSString stringWithFormat:@"마지막 업데이트 %02ld:%02ld:%02ld", hour, minute, second];
    self.updateLabel.text = updateTime;
    
    [self updateMenu:data];
}

- (void) changeSegment {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    NSInteger hour = [components hour];
    
    if(hour < 10) {
        [self.timeSegment setSelectedSegmentIndex:0];
    }
    else if(hour >= 10 && hour < 15) {
        [self.timeSegment setSelectedSegmentIndex:1];
    }
    else if(hour >= 15) {
        [self.timeSegment setSelectedSegmentIndex:2];
    }
}

#pragma mark - IBActions

- (IBAction)refresh:(id)sender {
    ////    [self.aiLoading startAnimating];
    //    [self fetchDataWithCompletion:^(BOOL newData, NSString *boardingTime, NSString *takeoffTime, NSString *landingTime,BOOL checkedIn,NSError *err) {
    ////        [self.aiLoading stopAnimating];
    //        if (newData)
    //        {
    ////            self.lblBoarding.text = boardingTime;
    ////            self.lblTakeoff.text = takeoffTime;
    ////            self.lblLanding.text = landingTime;
    ////            [self updateCheckinStatusUI:checkedIn];
    //        }
    //    }];
    
    NSLog(@"%@", self.dateLabel.text);
    //    if( ! [self.dateLabel.text isEqualToString:@"로딩중..."]) {
    self.dateLabel.text = @"로딩중...";
    self.updateLabel.text = @"로딩중...";
    [self changeSegment];
    [self loadData];
    //    }
}

- (IBAction)timeChanged:(id)sender {
    //    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    //    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    [self updateMenu:[self oldJson]];
}

- (IBAction)goToApp:(id)sender {
    NSURL *url = [NSURL URLWithString:@"taekbab://openTab?index=1"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (IBAction)openMsg:(id)sender {
    if(self.url && [self.url length] > 0) {
        NSURL *url = [NSURL URLWithString:self.url];
        [self.extensionContext openURL:url completionHandler:nil];
    }
}

@end
