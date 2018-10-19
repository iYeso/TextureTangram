//
//  TangramDefaultDataSourceHelper.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@interface TangramDefaultDataSourceHelper : NSObject

- (NSMutableArray<TangramLayoutComponent *> *)layoutComponentsForContents:(NSArray *)contents;

@end
