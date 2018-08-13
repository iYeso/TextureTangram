//
//  TangramLayoutComponent.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@implementation TangramLayoutComponent


- (CGFloat)computeLayouts {
    if ([self.headerInfo respondsToSelector:@selector(computeHeight)]&&[self.footerInfo respondsToSelector:@selector(computeHeight)]) {
        [self.headerInfo computeHeight];
        [self.footerInfo computeHeight];
        return CGRectGetHeight(self.headerInfo.frame) + CGRectGetHeight(self.footerInfo.frame);
    } else {
        return 0;
    }
}

@end
