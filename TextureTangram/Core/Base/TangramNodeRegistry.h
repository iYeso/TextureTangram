//
//  TangramNodeRegistry.h
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TangramNodeRegistry : NSObject

+ (void)registerFromDictionary:(NSDictionary<NSString *, Class> *)dictionary;

+ (void)registerClass:(nonnull Class)cls forType:(nonnull NSString *)type;

+ (nullable Class)classForType:(NSString *)type;


@end

