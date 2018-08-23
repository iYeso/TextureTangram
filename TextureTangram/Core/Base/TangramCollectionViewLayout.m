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


#import "TangramCollectionViewLayout.h"
#import "TangramInlineLayoutComponent.h"

NSString *const TangramCollectionViewBackgroundDecoratedKind = @"TangramCollectionViewBackgroundDecoratedKind";
NSString *const TangramCollectionViewSupplementaryKindHeader = @"TangramCollectionViewSupplementaryKindHeader";
NSString *const TangramCollectionViewSupplementaryKindFooter = @"TangramCollectionViewSupplementaryKindFooter";

@interface TangramCollectionViewLayout()

@property (nonatomic) CGSize contentSize;
@end

@implementation TangramCollectionViewLayout

#pragma mark - override method for UICollectionViewLayout

- (void)setLayoutComponents:(NSArray<TangramLayoutComponent *> *)layoutComponents {
    _layoutComponents = layoutComponents;
}


+ (Class)layoutAttributesClass {
    return [UICollectionViewLayoutAttributes class];
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
    
    [self calculateLayout];
    [self layouStickyNode];

    
}

- (void)layouStickyNode {
    
    if (_stickyIndex.integerValue >= self.layoutComponents.count) {
        return;
    }
    CGFloat adjuestInset;
    if (@available(iOS 11.0, *)) {
        adjuestInset = self.collectionView.adjustedContentInset.top;
    } else {
        adjuestInset = self.collectionView.contentInset.top;
    }
    
    TangramLayoutComponent *stickyComponent = self.layoutComponents[_stickyIndex.integerValue];
    CGFloat y = (self.collectionView.contentOffset.y+ adjuestInset> stickyComponent.layoutOrigin.y)?self.collectionView.contentOffset.y+adjuestInset:stickyComponent.layoutOrigin.y;
    CGRect componentRect = CGRectMake(stickyComponent.layoutOrigin.x, y, stickyComponent.width, stickyComponent.height);
    _stickyNode.frame = componentRect;
}

- (void)calculateLayout {
    TangramLayoutComponent *last = nil; // 上一个布局，用来计算最大margin
    CGFloat height = 0;
    _stickyIndex = nil;
    NSUInteger stickyIndex = 0;
    BOOL foundSticky = NO;
    for (NSInteger i = 0; i < self.layoutComponents.count; i++) {
        TangramLayoutComponent *component = self.layoutComponents[i];
        if (component.pinnedType == TangramLayoutComponentPinnedTypeTop) {
            stickyIndex = i;
            foundSticky = YES;
        }
        CGFloat maxMargin = MAX(last.margin.bottom, component.margin.top);
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - component.margin.left - component.margin.right;
        // 更新每一个item的高度
        if (!component.isInlineLayout) {
            for (NSInteger j = 0; j < component.itemInfos.count; j++) {
                TangramComponentDescriptor * item = component.itemInfos[j];
                CGFloat itemHeight = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]].height;
                item.expectedHeight = itemHeight;
            }
        }
        CGPoint origin = CGPointMake(component.margin.left, last.layoutOrigin.y + last.height + maxMargin);
        [component computeLayoutsWithOrigin:origin width:width];
        height += component.height;
        height += maxMargin;
        if (i == self.layoutComponents.count-1) {
            height += component.margin.bottom;
        }
        last = component;
        
    }
    
    if (!foundSticky) {
        [_stickyNode removeFromSupernode];
        _stickyNode = nil;
    } else  {
        _stickyIndex = @(stickyIndex);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:stickyIndex];
        ASDisplayNode *node = [self.collectionNode.dataSource collectionNode:self.collectionNode nodeBlockForItemAtIndexPath:indexPath]();
        _stickyNode = node;
        [self.collectionNode addSubnode:_stickyNode];
    }
    
    self.cacheHeight = height;
    _contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), _cacheHeight);
}

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.

// 找到可显示的视图，返回其布局属性
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 存在吸顶结点的话，显示吸顶结点。放在这里不是很好，但是没找到更好的时机
    if (self.stickyNode && self.collectionNode.visibleNodes.count) {
        self.stickyNode.hidden = NO;
    }

    NSMutableArray *visibleLayoutAttributes = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    for (NSInteger i = 0; i < sectionCount; i++) {
        
        TangramLayoutComponent *component = self.layoutComponents[i];
        CGRect componentRect = CGRectMake(component.layoutOrigin.x, component.layoutOrigin.y, component.width, component.height);
        // 查找符合规格的section
        if (!CGRectIntersectsRect(componentRect, rect)) {
            continue;
        }
        // 头部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:TangramCollectionViewSupplementaryKindHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            if (attributes) {
                [visibleLayoutAttributes addObject:attributes];
            }
            
        }
        
        // 尾部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:TangramCollectionViewSupplementaryKindFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            if (attributes) {
                [visibleLayoutAttributes addObject:attributes];
            }
        }
        
        if (component.isInlineLayout) {
            // 内联的cell
            TangramInlineLayoutComponent *inlineLayout = (TangramInlineLayoutComponent *)component;
            if (CGRectIntersectsRect(inlineLayout.inlineCellFrame, rect)) {
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
                if (attributes) {
                    [visibleLayoutAttributes addObject:attributes];
                }
            }
        }
        else {
            // cell
            // 优化：找到一个不在rect内的，就退出循环。
            // TODO： 采用类似二分法的方法查找；这个不是很必要，10000个item都不会很占用CPU
            NSInteger numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
            BOOL found = NO;
            for (NSInteger j = 0; j < numberOfItems; j++) {
                TangramComponentDescriptor * descriptor = component.itemInfos[j];
                
                if (CGRectIntersectsRect(descriptor.frame, rect)) {
                    UICollectionViewLayoutAttributes *attributes =[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    if (attributes) {
                        [visibleLayoutAttributes addObject:attributes];
                        found = YES;
                    }
                    
                } else if (found) {
                    break;
                }
                
            }
        }
        
    }
    if (visibleLayoutAttributes.count) {
        return visibleLayoutAttributes;
    } else {
        return nil;
    }
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
    
    if (layoutComponent.isInlineLayout) {
        // 内联的cell
        TangramInlineLayoutComponent *inlineLayout = (TangramInlineLayoutComponent *)layoutComponent;
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = inlineLayout.inlineCellFrame;
        return attributes;
        
    } else {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = layoutComponent.itemInfos[indexPath.row].frame;
        return attributes;
    }
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        return nil;
    }
    TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    if ([elementKind isEqualToString:TangramCollectionViewSupplementaryKindHeader]) {
        layoutAttributes.frame = layoutComponent.headerInfo.frame;
    } else if ([elementKind isEqualToString:TangramCollectionViewSupplementaryKindFooter]) {
        layoutAttributes.frame = layoutComponent.footerInfo.frame;
    } else {
        layoutAttributes = nil;
    }
    layoutAttributes.zIndex = 1;
    
    return layoutAttributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // return YES to cause the collection view to requery the layout for geometry information
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}



- (CGSize)collectionViewContentSize {
    return _contentSize;
}

@end
