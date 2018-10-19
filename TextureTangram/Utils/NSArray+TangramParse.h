//
//  NSArray+TangramParse.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (TangramParse)

- (UIEdgeInsets)parseInsets;

/**
 递归地移除所有的属性
 
 @return 一个新的NSArray对象
 */
- (NSArray *)tan_removeNullValues;

@end
