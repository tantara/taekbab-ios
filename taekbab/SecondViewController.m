//
//  SecondViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 7..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "SecondViewController.h"

#import "MyUISwitch.h"
#import "BuildingConfig.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    self.dataJson = [shared valueForKey:@"json"];
}

- (void) viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = NSStringFromClass([self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
//    NSDictionary *json = [shared valueForKey:@"json"];
    NSArray *sections = [self.dataJson valueForKey:@"sections"];
    
    NSString *name = [[sections objectAtIndex:section] objectForKey:@"name"];
    
    return name;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSDictionary *sections = [self.dataJson objectForKey:@"sections"];
    NSLog(@"%@", sections);
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *build = [self.dataJson objectForKey:@"buildings"];
    NSArray *sections = [self.dataJson objectForKey:@"sections"];
    NSDictionary *buildings = [[sections objectAtIndex:section] objectForKey:@"buildings"];
    return [buildings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
//    NSDictionary *json = [shared valueForKey:@"json"];
    NSArray *sections = [self.dataJson valueForKey:@"sections"];
    NSArray *buildings = [[sections objectAtIndex:indexPath.section] objectForKey:@"buildings"];
    
    NSString *name = [[buildings objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *code = [[buildings objectAtIndex:indexPath.row] objectForKey:@"code"];
    
    cell.textLabel.text = name;
    MyUISwitch *aSwitch = [[MyUISwitch alloc] init];
    [aSwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
    
    NSString *checked = [shared objectForKey:code];
    BOOL toggle = NO;
    if(checked && [checked isEqualToString:@"true"])
        toggle = YES;
    else
        toggle = NO;
    
    aSwitch.buildCode = code;
    
    UIColor * color = [ColorUtils globalColor];
    [aSwitch setOnTintColor:color];
    [aSwitch setOn:toggle animated:NO];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = aSwitch;
    
    return cell;
}

#pragma mark - view

- (IBAction)switched:(id)sender {
    MyUISwitch *aSwitch = (MyUISwitch*)sender;
    BOOL selected = aSwitch.isOn;
    NSString *code = aSwitch.buildCode;
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    if(selected) {
        [shared setObject:@"true" forKey:code];
    } else {
        [shared setObject:@"false" forKey:code];
    }
    [shared setObject:@"true" forKey:@"initialized"];
    [shared synchronize];
}

- (void) loadData {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    NSDictionary *json = [shared valueForKey:@"json"];
    
    if(json) {
        self.dataJson = json;
        [self updateUI:json];
    }
    
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:API_PATH]];
    MyRequest *req = [MyRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    
    NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    [shared setObject:dataJson forKey:@"json"];
    [shared synchronize];
    
    self.dataJson = dataJson;
    [self updateUI:dataJson];
}

- (void) updateUI:(NSDictionary*) json {
    [self.tableView reloadData];
    return;
    NSDictionary *buildings = [json objectForKey:@"buildings"];
    
    NSLog(@"%@", buildings);
    
    CGRect mainRect = self.view.frame;
    
    int height = 0;
    for(NSDictionary* building in buildings) {
        NSString *name = [building objectForKey:@"name"];
        NSString *code = [building objectForKey:@"code"];
        
        BuildingConfig *customView = [BuildingConfig customView:mainRect];
        [customView setName:name];
        [customView setBuildCode:code];
        [customView setSwitch:[customView isChecked]];
        
        CGRect frame = customView.frame;
        frame.origin.y = height;
        height += frame.size.height;
        customView.frame = frame;
    }
    
    NSLog(@"%@", json);
}

- (IBAction)refresh:(id)sender {
    [self loadData];
}

@end

