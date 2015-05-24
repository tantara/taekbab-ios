//
//  Menu.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 8..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "Menu.h"

@implementation Menu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)customView:(CGRect)mainRect {
    Menu *customView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil] lastObject];
    CGRect viewFrame = customView.frame;
    CGFloat scale = [UIScreen mainScreen].scale;
    viewFrame.size.width = mainRect.size.width;
    
    customView.frame = viewFrame;
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[Menu class]])
        return customView;
    else
        return nil;
}

- (void)setName:(NSString *)name {
//    name = @"우걍먈ㄴ얄먄얆냥ㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄹㅁ";
    self.nameLabel.text = name;
}

- (void)setPrice:(NSString*)price {
    self.priceLabel.text =[NSString stringWithFormat:@"%@원", price];
}

@end
