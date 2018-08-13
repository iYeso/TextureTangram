//
//  TangramGridLayoutComponet.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramGridLayoutComponet.h"

@implementation TangramGridLayoutComponet

- (instancetype)init {
    self = [super init];
    if (self) {
        _maximumColumn = 1;
    }
    return self;
}

- (CGFloat)computeLayouts {
    CGFloat height = [super computeLayouts];
    
    for (NSInteger i = 0; i < self.itemInfos.count; i++) {
        
    }
    
    return height;
}

@end
