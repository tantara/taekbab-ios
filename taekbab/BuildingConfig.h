//
//  BuildingConfig.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 21..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingConfig : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *displaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) NSString *code;

- (IBAction)switched:(id)sender;
- (void)setName:(NSString *)name;
- (void)setBuildCode:(NSString *)code;
- (void)setSwitch:(BOOL)toggle;
+ (BOOL) isChecked:(NSString*)code;
+ (BOOL) isInitialized;

- (BOOL) isChecked;


+ (id)customView:(CGRect)mainRect;
@end
