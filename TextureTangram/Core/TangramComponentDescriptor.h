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

@property (nonatomic, strong) NSString *type; ///< UI组件的类型

@property (nonatomic) CGRect frame;

@optional

- (void)computeHeight; ///< 自计算高度


@end
