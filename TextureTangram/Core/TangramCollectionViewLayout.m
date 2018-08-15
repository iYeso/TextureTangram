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

@property (nonatomic) CGSize contentSize;
@property (nonatomic, strong) NSMutableDictionary *cellAttributes;
@property (nonatomic, strong) NSMutableDictionary *supplementaryViewAttributes;
@property (nonatomic, strong) NSMutableDictionary *decoratedViewAttributes;

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
    _contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), _cacheHeight);
    self.cellAttributes = [NSMutableDictionary dictionary];
    self.supplementaryViewAttributes = [NSMutableDictionary dictionary];
    self.decoratedViewAttributes = [NSMutableDictionary dictionary];
}

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *visibleLayoutAttributes = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    for (NSInteger i = 0; i < sectionCount; i++) {
        
        TangramLayoutComponent *component = self.layoutComponents[i];
        // 头部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            [visibleLayoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]]];
        }
        
        // 尾部
        if (component.headerInfo && CGRectIntersectsRect(component.headerInfo.frame, rect)) {
            [visibleLayoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]]];
        }
        
        // cell
        
        NSInteger numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfItems; j++) {
            id<TangramComponentDescriptor> descriptor = component.itemInfos[j];
            if (CGRectIntersectsRect(descriptor.frame, rect)) {
                [visibleLayoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
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
    UICollectionViewLayoutAttributes *attributes = self.cellAttributes[indexPath];
    if (!attributes) {
        TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = layoutComponent.itemInfos[indexPath.row].frame;
        self.cellAttributes[indexPath] = attributes;
    }
    
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%@%@",@(indexPath.section),elementKind];
    UICollectionViewLayoutAttributes *layoutAttributes = self.supplementaryViewAttributes[key];
    if (!layoutAttributes) {
        TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            layoutAttributes.frame = layoutComponent.headerInfo.frame;
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            layoutAttributes.frame = layoutComponent.footerInfo.frame;
        } else {
            layoutAttributes = nil;
        }
        layoutAttributes.zIndex = 1;
        self.supplementaryViewAttributes[key] = layoutAttributes;
    }
    
    
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
