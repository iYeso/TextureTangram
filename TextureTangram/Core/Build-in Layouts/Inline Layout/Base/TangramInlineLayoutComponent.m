//
//  TangramInlineLayoutComponent.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/23.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramInlineLayoutComponent.h"

@implementation TangramInlineLayoutComponent

- (instancetype)init {
    if (self = [super init]) {
        _inlineModel  = [TangramInlineCellInfo new];
        _inlineModel.layoutComponent = self;
        _inlineModel.type = self.type.copy;
    }
    return self;
}

- (NSString *)type {
    return @"placeholder";
}

- (BOOL)isInlineLayout {
    return YES;
}


- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
}

@end
