//
//  NSDictionary+TangramParse.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "NSDictionary+TangramParse.h"
#import "NSArray+TangramParse.h"

@implementation NSDictionary (TangramParse)

- (NSDictionary *)tan_removeNullValues {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
    NSArray *keys = self.allKeys;
    for (id key in keys) {
        id value = dict[key];
        if ([value isKindOfClass:NSNull.class]) {
            dict[key] = nil;
        } else if ([value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSArray.class]) {
            dict[key] = [value tan_removeNullValues];
        }
    }
    return dict.copy;
}

@end
