//
//  TangramLayoutComponent.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramLayoutComponent.h"

@implementation TangramLayoutComponent

- (TangramComponentDescriptor *)headerInfo {
    if (!_headerInfo) {
        _headerInfo = TangramComponentDescriptor.new;
        _headerInfo.expectedHeight = 0;
    }
    return _headerInfo;
}

- (TangramComponentDescriptor *)footerInfo {
    if (!_footerInfo) {
        _footerInfo = TangramComponentDescriptor.new;
        _footerInfo.expectedHeight = 0;
    }
    return _footerInfo;
}


- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    self.width = width;
    self.layoutOrigin = origin;
}

@end
