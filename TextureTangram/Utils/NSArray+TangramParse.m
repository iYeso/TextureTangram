//
//  NSArray+TangramParse.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "NSArray+TangramParse.h"

@implementation NSArray (TangramParse)
- (UIEdgeInsets)parseInsets {
    NSArray *insets = self;
    
    if ([self isKindOfClass:NSString.class]) {
        NSData *data = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        insets = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return UIEdgeInsetsZero;
        }
    }
    
    if (insets.count != 4) {
        return UIEdgeInsetsZero;
    }
    
    return UIEdgeInsetsMake([insets[0] doubleValue],
                            [insets[3] doubleValue],
                            [insets[2] doubleValue],
                            [insets[1] doubleValue]);
    
}

- (NSArray *)tan_removeNullValues {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    for (NSInteger i = 0; i < array.count; i++) {
        id item = array[i];
        if ([array[i] isKindOfClass:NSNull.class]) {
            [array removeObject:item];
            i--;
            continue;
        }
        if ([array[i] isKindOfClass:NSArray.class] || [array[i] isKindOfClass:NSDictionary.class]) {
            array[i] = [array[i] tan_removeNullValues];
        }
    }
    return array.copy;
}

@end
