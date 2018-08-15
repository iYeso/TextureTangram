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
    CGFloat headerHeight = self.headerInfo.expectedHeight;
    if ([self.headerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        headerHeight =[self.headerInfo computeHeightWithWidth:width];
    }
    
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    
    assert(_maximumColumn > 0);
    // 设置每个item的frame
    CGFloat itemWidth = (self.width - (_maximumColumn-1) * self.horizontalInterItemsSpace - self.insets.left - self.insets.right) / _maximumColumn; //TODO: 计算不一样的宽度
    NSUInteger column = 0;
    NSUInteger row = 0;
    
    CGFloat itemsOriginY = self.insets.top + self.layoutOrigin.y + headerHeight;
    CGFloat y = itemsOriginY;
    NSUInteger rowMaxHeight = 0;
    NSUInteger rowMaxHeightRowNumber = 0; //记住当前行的最大高度；
    for (NSInteger i = 0; i < self.itemInfos.count; i++) {
        id<TangramComponentDescriptor> descriptor = self.itemInfos[i];
        column = (i%_maximumColumn);
        row = (i/_maximumColumn);
        CGFloat x = self.insets.left + self.layoutOrigin.x + (self.horizontalInterItemsSpace+itemWidth) * column;
        descriptor.width = itemWidth;
        if (row != rowMaxHeightRowNumber) {
            y += rowMaxHeight + self.verticalInterItemsSpace;
            rowMaxHeightRowNumber = row;
            rowMaxHeight = descriptor.expectedHeight;
        }
        if (descriptor.expectedHeight > rowMaxHeight) {
            rowMaxHeight = descriptor.expectedHeight;
        }
        descriptor.frame = CGRectMake(x, y, itemWidth,descriptor.expectedHeight);
    }
    
    self.height = y - itemsOriginY + rowMaxHeight + footerHeight + self.insets.bottom;
}

@end
