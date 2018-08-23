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

#import "TangramOnePlusLayoutComponent.h"

@implementation TangramOnePlusLayoutComponent

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    CGFloat headerHeight = CGRectGetHeight(self.headerInfo.frame);
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    
    CGFloat rowRatio = 1;
    if (self.rowPartitions.count == 2) {
        rowRatio =[self.rowPartitions[0] doubleValue]/([self.rowPartitions[0] doubleValue] + [self.rowPartitions[1] doubleValue]);
    }
    
    CGFloat totalItemWidth = (width - self.insets.left - self.insets.right);
    TangramItemInfo * mainItem = self.itemInfos[0];
    mainItem.width = totalItemWidth/2;
    mainItem.frame = CGRectMake(origin.x + self.insets.left, origin.y + self.insets.top + headerHeight, mainItem.width, mainItem.expectedHeight);
    
    TangramItemInfo * secondItem = self.itemInfos[1];
    CGFloat secondItemHeight = rowRatio * mainItem.expectedHeight;
    secondItem.expectedHeight = secondItemHeight;
    CGFloat othersHeight = mainItem.expectedHeight - secondItemHeight;
    secondItem.frame = CGRectMake(CGRectGetMaxX(mainItem.frame), CGRectGetMinY(mainItem.frame), totalItemWidth/2, secondItemHeight);
    
    // 其他
    if (self.itemInfos.count > 2) {
        CGFloat otherWidth = totalItemWidth/(self.itemInfos.count-2)/2;
        for (NSInteger i = 2; i < self.itemInfos.count; i++) {
            TangramItemInfo * item = self.itemInfos[i];
            item.expectedHeight = othersHeight;
            NSInteger innerRowNumber = i - 2;
            item.frame = CGRectMake(CGRectGetMaxX(mainItem.frame)+innerRowNumber*otherWidth, CGRectGetMaxY(secondItem.frame), otherWidth, othersHeight);
        }
    }
    
    
    self.height = self.insets.top + mainItem.expectedHeight + self.insets.bottom + headerHeight + footerHeight;
    
    self.footerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y+self.height-footerHeight, width, footerHeight);
    
    
}

@end
