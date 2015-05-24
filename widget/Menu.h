//
//  Menu.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 4. 8..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Menu : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

+ (id) customView:(CGRect)mainRect;
- (void) setName:(NSString*)name;
- (void) setPrice:(NSString*)price;

@end
