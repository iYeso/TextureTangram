// Copyright ZZinKin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TangramWaterFlowLayoutComponent.h"

@implementation TangramWaterFlowLayoutComponent

- (instancetype)init {
    self = [super init];
    if (self) {
        _maximumColumn = 1;
    }
    return self;
}

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    CGFloat headerHeight = CGRectGetHeight(self.headerInfo.frame);
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    
    assert(_maximumColumn > 0);
    // 设置每个item的frame
    CGFloat itemWidth = (self.width - (_maximumColumn-1) * self.horizontalInterItemsSpace - self.insets.left - self.insets.right) / _maximumColumn;
    NSUInteger column = 0;
    
    // 跟固定高度的不一样，瀑布流每次只找最短的一列尾部添加item
    CGFloat itemsOriginY = self.insets.top + self.layoutOrigin.y + headerHeight;
    CGFloat y = itemsOriginY;
    NSMutableArray *columnYs = [NSMutableArray array];
    for (NSInteger i = 0; i < _maximumColumn; i++) {
        [columnYs addObject:@(y)];
    }
    
    for (NSInteger i = 0; i < self.itemInfos.count; i++) {
        TangramComponentDescriptor *descriptor = self.itemInfos[i];
        
        // 查找最短列
        column = 0;
        y = (CGFloat)[columnYs.firstObject doubleValue];
        for (NSInteger j = 0; j < columnYs.count; j++) {
            CGFloat columnY = (CGFloat)[columnYs[j] doubleValue];
            if (columnY < y) {
                y = columnY;
                column = j;
            }
        }
        CGFloat x = self.insets.left + self.layoutOrigin.x + (self.horizontalInterItemsSpace+itemWidth) * column;
        descriptor.width = itemWidth;
        descriptor.frame = CGRectMake(x, y, itemWidth,descriptor.expectedHeight);
        columnYs[column] = @(y + descriptor.expectedHeight+self.verticalInterItemsSpace); //更新列的Y值
    }
    
    // 查找出最长的列，算出瀑布流高度
    y = 0;
    for (NSInteger j = 0; j < columnYs.count; j++) {
        CGFloat columnY = (CGFloat)[columnYs[j] doubleValue];
        if (columnY > y) {
            y = columnY;
        }
    }
    
    // 减去多加了的verticalSpace
    self.height = y - itemsOriginY + headerHeight  + footerHeight + self.insets.bottom +  self.insets.top - self.verticalInterItemsSpace;
    self.footerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y+self.height-footerHeight, width, footerHeight);
}

@end
