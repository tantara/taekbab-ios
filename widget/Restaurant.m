//
//  Restaurant.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 8..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (id)customView:(CGRect)mainRect {
    Restaurant *customView = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantView" owner:nil options:nil] lastObject];
    CGRect viewFrame = customView.frame;
    CGFloat scale = [UIScreen mainScreen].scale;
    viewFrame.size.width = mainRect.size.width;
    customView.frame = viewFrame;
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[Restaurant class]])
        return customView;
    else
        return nil;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

@end
