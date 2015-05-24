//
//  BuildingConfig.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 21..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "BuildingConfig.h"

#import "ColorUtils.h"

@implementation BuildingConfig

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)customView:(CGRect)mainRect {
    BuildingConfig *customView = [[[NSBundle mainBundle] loadNibNamed:@"BuildingConfigView" owner:nil options:nil] lastObject];
    CGRect viewFrame = customView.frame;
    viewFrame.size.width = mainRect.size.width;//CGRectGetWidth(mainRect);
    customView.frame = viewFrame;
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[BuildingConfig class]])
        return customView;
    else
        return nil;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setBuildCode:(NSString *)code {
    self.code = code;
}

- (void)setSwitch:(BOOL)toggle {
    UIColor * color = [ColorUtils globalColor];
    [self.displaySwitch setOnTintColor:color];
    [self.displaySwitch setOn:toggle animated:NO];
}

+ (BOOL) isInitialized {
    NSString *code = @"initialized";
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    NSString *checked = [shared objectForKey:code];
    if(checked && [checked isEqualToString:@"true"])
        return YES;
    else
        return NO;
}

+ (BOOL) isChecked:(NSString*)code {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    NSString *checked = [shared objectForKey:code];
    if(checked && [checked isEqualToString:@"true"])
        return YES;
    else
        return NO;
}

- (BOOL) isChecked {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    NSString *checked = [shared objectForKey:self.code];
    if(checked && [checked isEqualToString:@"true"])
        return YES;
    else
        return NO;
}

- (IBAction)switched:(id)sender {
    BOOL selected = ((UISwitch*)sender).isOn;
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tantara.taekbab"];
    if(selected) {
        [shared setObject:@"true" forKey:self.code];
    } else {
        [shared setObject:@"false" forKey:self.code];
    }
    [shared setObject:@"true" forKey:@"initialized"];
    [shared synchronize];
}
@end
