//
//  MyUISwitch.m
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 19..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import "MyUISwitch.h"

#import "ColorUtils.h"

@implementation MyUISwitch

- (id) init {
    self = [super init];
    if(self) {
        UIColor * color = [ColorUtils globalColor];
        [self setOnTintColor:color];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIColor * color = [ColorUtils globalColor];
        [self setOnTintColor:color];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIColor * color = [ColorUtils globalColor];
        [self setOnTintColor:color];
    }
    return self;
}

@end
