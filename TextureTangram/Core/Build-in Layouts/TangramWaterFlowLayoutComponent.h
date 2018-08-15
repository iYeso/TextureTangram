//
//  TangramWaterFlowLayoutComponent.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/15.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@interface TangramWaterFlowLayoutComponent : TangramLayoutComponent

@property (nonatomic) NSUInteger maximumColumn; ///< 最大列数，默认1
@property (nonatomic) CGFloat verticalInterItemsSpace; ///< 垂直方向每个组件的间距；vGap
@property (nonatomic) CGFloat horizontalInterItemsSpace; ///< 垂直方向每个组件的距离; hGap

@end
