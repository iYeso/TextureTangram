//
//  TangramComputable.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 对应每个组件的model，新增的model继承它
 */
@interface TangramComponentDescriptor: NSObject

@property (nonatomic, strong) NSString *type; ///< UI组件的类型
@property (nonatomic) CGRect frame; ///< 布局的frame，未完成布局之前，使用此属性会不准确
@property (nonatomic) CGFloat width; ///< 控件的宽度，第一次布局的时候会设置这个属性。
@property (nonatomic) CGFloat expectedHeight;
@property (nonatomic) BOOL fixHeight; ///<是否为灵活高度

- (CGFloat)computeHeightWithWidth:(CGFloat)width; ///< 自计算高度；会影响expectedHeight属性


@end
