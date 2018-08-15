//
//  TangramComputable.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 对应每个组件的model，新增的model需要实现这个协议 */
@protocol TangramComponentDescriptor <NSObject>

@property (nonatomic, copy) NSString *type; ///< UI组件的类型

@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat expectedHeight;

@optional

- (CGFloat)computeHeightWithWidth:(CGFloat)width; ///< 自计算高度


@end
