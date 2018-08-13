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

NSString *const TangramCollectionViewBackgroundDecoratedKind = @"TangramCollectionViewBackgroundDecoratedKind";

@interface TangramCollectionViewLayout()

@property (nonatomic) CGFloat cacheHeight;

@end

@implementation TangramCollectionViewLayout

#pragma mark - override method for UICollectionViewLayout


+ (Class)layoutAttributesClass {
    return [UICollectionViewLayoutAttributes class];
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
    
    TangramLayoutComponent *last = nil; // 上一个布局，用来计算最大margin
    CGFloat height = 0;
    for (NSInteger i = 0; i < self.layoutComponents.count; i++) {
        TangramLayoutComponent *component = self.layoutComponents[i];
        CGFloat maxMargin = MAX(last.margin.bottom, component.margin.top);
        component.width = CGRectGetWidth(self.collectionView.frame) - component.margin.left - component.margin.right;
        component.layoutOrigin = CGPointMake(component.margin.left, last.layoutOrigin.y + last.height + maxMargin + component.insets.top);
        [component computeLayouts];
        last = component;
        height += component.height;
    }
    _cacheHeight = height;
    
}

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *visibleLayoutAttributes = [NSMutableArray array];
    NSInteger i = 0;
    for (TangramLayoutComponent *component in self.layoutComponents) {
        
        // 头部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            [visibleLayoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]]];
        }
        
        // 尾部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            [visibleLayoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]]];
        }
        
        // cell
        NSInteger j = 0;
        for (id<TangramComponentDescriptor> descriptor in component.itemInfos) {
            if (CGRectIntersectsRect(descriptor.frame, rect)) {
                [visibleLayoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
            }
            j++;
        }
        
        i++;
    }
    return visibleLayoutAttributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = layoutComponent.itemInfos[indexPath.row].frame;
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        layoutAttributes.frame = layoutComponent.headerInfo.frame;
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        layoutAttributes.frame = layoutComponent.footerInfo.frame;
    } else {
        return nil;
    }
    layoutAttributes.zIndex = 1;
    return layoutAttributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // return YES to cause the collection view to requery the layout for geometry information
    return YES;
}



- (CGSize)collectionViewContentSize {
    return UIScreen.mainScreen.bounds.size;
}

@end
