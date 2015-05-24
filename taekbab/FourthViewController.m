//
//  FourthViewController.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 19..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "FourthViewController.h"

#import "MyUISwitch.h"
#import "MyWebViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *pushOn = @"false";
    if([MyCache hasKey:@"pushOn"]) {
        pushOn = [MyCache load:@"pushOn"];
    }
    NSString *version = [Agent currentAppVersion];
    
    self.tableHeaders = @[@"알림", @"버그 및 제안", @"기타", @""];
    self.tableData = @{
                       @"알림": @{
                               @"푸시 알림": @{
                                       @"type": @"switch",
                                       @"value": pushOn,
                                       @"function": @"togglePush:"
                                       }
                               },
                       @"버그 및 제안": @{
                               @"메일로": @{
                                       @"type": @"arrow",
                                       @"value": @"",
                                       @"function": @"sendMail"
                                       },
                               @"페이스북으로": @{
                                       @"type": @"arrow",
                                       @"value": @"@taekmin.kim",
                                       @"function": @"openFacebook"
                                       }
                               },
                       @"기타": @{
                               @"버전 정보": @{
                                       @"type": @"arrow",
                                       @"value": version,
                                       @"function": @"showVersion"
                                       },
                               @"개발자": @{
                                       @"type": @"text",
                                       @"value": @"tantara",
                                       @"function": @"openFacebook"
                                       },
                               },
                       @"": @{
                               @"도와준 사람들": @{
                                       @"type": @"arrow",
                                       @"value": @"",
                                       @"function": @"openThanksTo"
                                       }
                               }
                       };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - table

//- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *key = [self.tableHeaders objectAtIndex:section];
//    
//    return key;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.tableHeaders objectAtIndex:section];
    
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.tableHeaders objectAtIndex:section];
    NSDictionary *rows = [self.tableData objectForKey:key];
    
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *key = [self.tableHeaders objectAtIndex:indexPath.section];
    NSDictionary *rows = [self.tableData objectForKey:key];
    NSString *name = [rows.allKeys objectAtIndex:indexPath.row];
    NSDictionary *data = [rows objectForKey:name];
    NSString *type = [data objectForKey:@"type"];
    NSString *value = [data objectForKey:@"value"];
    NSString *function = [data objectForKey:@"function"];
    
    // cell content
    cell.textLabel.text = name;
    
    // cell accessory
    if([type isEqualToString:@"arrow"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 30)];
        label.text = value;
        [label setTextAlignment:NSTextAlignmentRight];
        cell.detailTextLabel.text = value;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([type isEqualToString:@"text"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 30)];
        label.text = value;
        [label setTextAlignment:NSTextAlignmentRight];
        cell.detailTextLabel.text = value;
    }
    else if([type isEqualToString:@"switch"]) {
        MyUISwitch *aSwitch = [[MyUISwitch alloc] init];
        SEL s = NSSelectorFromString(function);
        [aSwitch addTarget:self action:s forControlEvents:UIControlEventValueChanged];
        
        // set toggle
        BOOL toggle = NO;
        if([value isEqualToString:@"true"]) {
            toggle = YES;
        }
        
        aSwitch.buildCode = value;
        [aSwitch setOn:toggle animated:NO];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = aSwitch;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.tableHeaders objectAtIndex:indexPath.section];
    NSDictionary *rows = [self.tableData objectForKey:key];
    NSString *name = [rows.allKeys objectAtIndex:indexPath.row];
    NSDictionary *data = [rows objectForKey:name];
//    NSString *type = [data objectForKey:@"type"];
//    NSString *value = [data objectForKey:@"value"];
    NSString *function = [data objectForKey:@"function"];
    
    SEL s = NSSelectorFromString(function);
    if([self respondsToSelector:s]) {
        [self performSelector:s];
    }
}

#pragma mark - row function

- (void) togglePush:(id)sender {
    MyUISwitch *mySwitch = (MyUISwitch*)sender;
    
    NSString *urlString = [BASE_URL stringByAppendingString:TOGGLE_PUSH_PATH];
    urlString = [urlString stringByAppendingFormat:@"?on=%@", mySwitch.buildCode];
    NSURL *url = [NSURL URLWithString:urlString];
    MyRequest *req = [MyRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    
    NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    BOOL on = [[dataJson objectForKey:@"on"] boolValue];
    if(on) {
        mySwitch.buildCode = @"true";
    } else {
        mySwitch.buildCode = @"false";
    }
    [mySwitch setOn:on animated:NO];
    [MyCache save:@"pushOn" withData:mySwitch.buildCode];
}

- (void) sendMail {
    NSString *emailTitle = @"[택밥] 버그 및 제안";
    // Email Content
    NSString *messageBody = @"택밥과 관련된 버그 혹은 기능 제안을 해주세요.\n\n이외에도 학교와 관련된 아이디어가 있으면 같이 해봐도 좋을 거 같아요!!\n\n\n\n*확인 후 메일을 꼭 드리겠습니다.";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"tantara.tm@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) showVersion {
    MyWebViewController *controller = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
    controller.currentUrl = [BASE_URL stringByAppendingString:VERSION_PATH];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];    
}

- (void) openFacebook {
    NSString *url = @"https://facebook.com/taekmin.kim";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void) openThanksTo {
    MyWebViewController *controller = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
    controller.currentUrl = [BASE_URL stringByAppendingString:THANKS_PATH];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - email
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
