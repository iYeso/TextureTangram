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
    self.headerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y, width, headerHeight);
    
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    

    assert(_maximumColumn > 0);
    assert(_maximumColumn == _columnPartitions.count);
    // 设置每个item的frame
    CGFloat totalItemWidth = (self.width - (_maximumColumn-1) * self.horizontalInterItemsSpace - self.insets.left - self.insets.right);
    NSUInteger column = 0;
    NSUInteger row = 0;
    double total = 0;
    NSMutableArray *itemWidths = [NSMutableArray arrayWithCapacity:_maximumColumn];
    for (NSInteger i = 0; i < _maximumColumn; i++) {
        total += [_columnPartitions[i] doubleValue];
    }
    for (NSInteger i = 0; i < _maximumColumn; i++) {
        [itemWidths addObject:@(totalItemWidth*[_columnPartitions[i] doubleValue]/total)];
    }
    
    CGFloat itemsOriginY = self.insets.top + self.layoutOrigin.y + headerHeight;
    CGFloat itemOriginX = self.insets.left + self.layoutOrigin.x;
    CGFloat y = itemsOriginY;
    CGFloat x = itemOriginX;
    NSUInteger rowMaxHeight = 0;
    NSUInteger rowMaxHeightRowNumber = 0; //记住当前行的最大高度；
    for (NSInteger i = 0; i < self.itemInfos.count; i++) {
        TangramComponentDescriptor *descriptor = self.itemInfos[i];
        column = (i%_maximumColumn);
        row = (i/_maximumColumn);
        CGFloat itemWidth = [itemWidths[column] doubleValue];
        descriptor.width = itemWidth;
        if (row != rowMaxHeightRowNumber) {
            y += rowMaxHeight + self.verticalInterItemsSpace;
            rowMaxHeightRowNumber = row;
            rowMaxHeight = descriptor.expectedHeight;
            x = itemOriginX;
        }
        if (descriptor.expectedHeight > rowMaxHeight) {
            rowMaxHeight = descriptor.expectedHeight;
        }
        descriptor.frame = CGRectMake(x, y, itemWidth,descriptor.expectedHeight);
        x += self.horizontalInterItemsSpace + itemWidth; //下个item的x
    }
    
    self.height = y - itemsOriginY + rowMaxHeight + headerHeight + footerHeight + self.insets.bottom;
    
    self.footerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y+self.height-footerHeight, width, footerHeight);
    
}

@end
