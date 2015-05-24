//
//  MyCache.h
//  taekbab
//
//  Created by Taekmin Kim on 2015. 5. 24..
//  Copyright (c) 2015년 Taekmin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCache : NSObject

+(void)save:(NSString*)key withData:(NSString*)data;
+(NSString*)load:(NSString*)key;
+(BOOL)hasKey:(NSString*)key;

@end
