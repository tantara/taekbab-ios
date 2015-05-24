//
//  Restaurant.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 8..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Restaurant : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (id) customView:(CGRect)mainRect;
- (void) setName:(NSString*)name;

@end
