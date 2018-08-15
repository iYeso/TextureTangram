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

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    CGFloat headerHeight = [self.headerInfo computeHeightWithWidth:width];
    CGFloat footerHeight = [self.footerInfo computeHeightWithWidth:width];
    
    assert(_maximumColumn > 0);
    // 设置每个item的frame
    CGFloat itemWidth = (self.width - (_maximumColumn-1) * self.horizontalInterItemsSpace - self.insets.left - self.insets.right) / _maximumColumn;
    for (NSInteger i = 0; i < self.itemInfos.count; i++) {
        id<TangramComponentDescriptor> descriptor = self.itemInfos[i];
        CGFloat x = self.insets.left + self.layoutOrigin.x + (self.horizontalInterItemsSpace+itemWidth) * (i%_maximumColumn);
        CGFloat y = self.insets.top + self.layoutOrigin.y + (self.verticalInterItemsSpace+descriptor.expectedHeight) * (i/_maximumColumn) + headerHeight;
        descriptor.frame = CGRectMake(x, y, itemWidth,descriptor.expectedHeight);
    }
    
    self.height = CGRectGetMaxY(self.itemInfos.lastObject.frame) + footerHeight - self.layoutOrigin.y;
}

@end
