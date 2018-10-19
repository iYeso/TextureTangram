//
//  NSDictionary+TangramParse.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TangramParse)

/**
 递归地移除所有的属性

 @return 一个新的NSDictionary对象
 */
- (NSDictionary *)tan_removeNullValues;

@end
