//
//  TangramNodeRegistry.m
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramNodeRegistry.h"

@interface TangramNodeRegistry()

@property (nonatomic, strong) NSMutableDictionary *registry; //FIXME: 这里线程不安全

@end

/// 注册表
@implementation TangramNodeRegistry

+  (instancetype)shared {
    static TangramNodeRegistry *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        instance.registry = [NSMutableDictionary dictionaryWithCapacity:8];
    });
    return instance;
}

+ (void)registerFromDictionary:(NSDictionary<NSString *,Class> *)dictionary {
    [[TangramNodeRegistry shared].registry addEntriesFromDictionary:dictionary];
}

+ (void)registerClass:(Class)cls forType:(NSString *)type {
    if (!type) {
        return;
    }
    [TangramNodeRegistry shared].registry[type] =  cls;
}

+ (Class)classForType:(NSString *)type {
    return [TangramNodeRegistry shared].registry[type];
}

@end
