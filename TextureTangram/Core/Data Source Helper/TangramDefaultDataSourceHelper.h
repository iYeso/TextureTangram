//
//  TangramDefaultDataSourceHelper.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@interface TangramDefaultDataSourceHelper : NSObject

/**
 根据json数据创建TangramLayoutComponent数组

 @param contents json转化的数组，需要去null处理
 
 */
- (NSMutableArray<TangramLayoutComponent *> *)layoutComponentsForContents:(NSArray *)contents;

@end
