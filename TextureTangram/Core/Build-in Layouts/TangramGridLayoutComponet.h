//
//  TangramGridLayoutComponet.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@interface TangramGridLayoutComponet : TangramLayoutComponent

@property (nonatomic) NSUInteger maximumColumn; ///< 最大列数，默认1
@property (nonatomic) double rowAspectRatio;  ///< 每一行宽高比； 对应aspectRatio
@property (nonatomic) CGFloat verticalInterItemsSpace; ///< 垂直方向每个组件的间距；vGap
@property (nonatomic) CGFloat horizontalInterItemsSpace; ///< 垂直方向每个组件的距离; hGap

///每列的百分比，如果是N列，可以只写Array中只写N-1项，最后一项会自动填充，如果加一起大于100，就按照填写的来算；示例：    ["30","30"] 或 [30",30]
@property (nonatomic) NSArray<NSNumber *> *columnPartitions;


@end
