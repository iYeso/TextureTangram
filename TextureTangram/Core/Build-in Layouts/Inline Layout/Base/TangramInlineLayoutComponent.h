//
//  TangramInlineLayoutComponent.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/23.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"
#import "TangramInlineCellInfo.h"

@interface TangramInlineLayoutComponent : TangramLayoutComponent

- (nonnull NSString *)type;

@property (nonatomic) CGRect inlineCellFrame;
@property (nonatomic, strong, nonnull) TangramInlineCellInfo *inlineModel; ///自动初始化一个inlineModel

@end
