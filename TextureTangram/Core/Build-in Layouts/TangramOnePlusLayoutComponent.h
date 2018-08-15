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

@property (nonatomic) NSArray *rowPartitions; ///< 垂直方向每个组件的间距；vGap

@end
