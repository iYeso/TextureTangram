//
//  TangramOnePlusLayoutComponent.h
//  TextureTangram
//
//  Created by cello on 2018/8/15.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

/** 1+N 布局 */
@interface TangramOnePlusLayoutComponent : TangramLayoutComponent

@property (nonatomic) NSArray *rowPartitions; ///< 右方的行高比例；最终的高度是左边的item定的

@end
