//
//  TangramOnePlusLayoutComponent.m
//  TextureTangram
//
//  Created by cello on 2018/8/15.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramOnePlusLayoutComponent.h"

@implementation TangramOnePlusLayoutComponent

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    CGFloat headerHeight = self.headerInfo.expectedHeight;
    if ([self.headerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        headerHeight =[self.headerInfo computeHeightWithWidth:width];
    }
    self.headerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y, width, headerHeight);
    
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    
    CGFloat rowRatio = 1;
    if (self.rowPartitions.count == 2) {
        rowRatio =[self.rowPartitions[0] doubleValue]/([self.rowPartitions[0] doubleValue] + [self.rowPartitions[1] doubleValue]);
    }
    
    CGFloat totalItemWidth = (width - self.insets.left - self.insets.right);
    TangramComponentDescriptor * mainItem = self.itemInfos[0];
    mainItem.width = totalItemWidth/2;
    mainItem.frame = CGRectMake(origin.x + self.insets.left, origin.y + self.insets.top, mainItem.width, mainItem.expectedHeight);
    
    TangramComponentDescriptor * secondItem = self.itemInfos[1];
    CGFloat secondItemHeight = rowRatio * mainItem.expectedHeight;
    secondItem.expectedHeight = secondItemHeight;
    CGFloat othersHeight = mainItem.expectedHeight - secondItemHeight;
    secondItem.frame = CGRectMake(CGRectGetMaxX(mainItem.frame), CGRectGetMinY(mainItem.frame), totalItemWidth/2, secondItemHeight);
    
    // 其他
    if (self.itemInfos.count > 2) {
        CGFloat otherWidth = totalItemWidth/(self.itemInfos.count-2)/2;
        for (NSInteger i = 2; i < self.itemInfos.count; i++) {
            TangramComponentDescriptor * item = self.itemInfos[i];
            item.expectedHeight = othersHeight;
            NSInteger innerRowNumber = i - 2;
            item.frame = CGRectMake(CGRectGetMaxX(mainItem.frame)+innerRowNumber*otherWidth, CGRectGetMaxY(secondItem.frame), otherWidth, othersHeight);
        }
    }
    
    
    self.height = self.insets.top + mainItem.expectedHeight + self.insets.bottom;
    
    self.footerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y+self.height-footerHeight, width, footerHeight);
}

@end
