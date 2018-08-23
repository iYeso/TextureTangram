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

#import "TangramHorizontalInlineLayoutComponent.h"
#import "TangramNodeRegistry.h"
#import "TangramItemNode.h"
#import "TangramInlineHorizontalScrollableNode.h"

NSString *TangramHorizontalInlineCellNodeType = @"horizontalscollable";

@implementation TangramHorizontalInlineLayoutComponent

+ (void)load {
    [TangramNodeRegistry registerClass:TangramInlineHorizontalScrollableNode.class forType:TangramHorizontalInlineCellNodeType];
}

- (NSString *)type {
    return TangramHorizontalInlineCellNodeType;
}

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    // self.height不需要计算，由外部设置
    CGFloat headerHeight = CGRectGetHeight(self.headerInfo.frame);
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    self.inlineCellFrame = CGRectMake(origin.x+self.insets.left,
                                      origin.y + headerHeight + self.insets.top,
                                      width-self.insets.left-self.insets.right,
                                      self.height-self.insets.top-self.insets.right);
}

#pragma mark - ASCollectionDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.scrollMarginLeft, 0, self.scrollMarginRight);
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.itemInfos.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramItemInfo *model = self.itemInfos[indexPath.row];
    return [self nodeBlockWithModel:model];
}

- (ASCellNodeBlock)nodeBlockWithModel:(TangramItemInfo *)model {
    return ^ASCellNode * _Nonnull(void) {
        Class nodeClass = [TangramNodeRegistry classForType:model.type];
        if (!model || !nodeClass || ![nodeClass isSubclassOfClass:TangramItemNode.class]) {
            return [TangramItemNode new];
        }
        TangramItemNode *node = (TangramItemNode*)[[nodeClass alloc] init];
        node.model = model;
        return node;
    };
}



@end
