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
@property (nonatomic) BOOL getExactHeight;


@end

@implementation TangramCollectionViewLayout

#pragma mark - override method for UICollectionViewLayout

- (void)setLayoutComponents:(NSArray<TangramLayoutComponent *> *)layoutComponents {
    _layoutComponents = layoutComponents;
    [self calculateLayout];
}


+ (Class)layoutAttributesClass {
    return [UICollectionViewLayoutAttributes class];
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
    static CFTimeInterval lastTime = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lastTime = CFAbsoluteTimeGetCurrent();
    });
    CFTimeInterval now =  CFAbsoluteTimeGetCurrent();
    if (now - lastTime < 5) { //只有初始化的时候才计算，这样处理貌似不太妥当；最好是不要放在 prepareLayout，然后item的height不是自己给定的，如果通过sizeForItemAtIndexPath来获取，必须要多次调用才行（因为item是自计算的）这个时机不好把握到
        [self calculateLayout];
    }
    
}

- (void)calculateLayout {
    TangramLayoutComponent *last = nil; // 上一个布局，用来计算最大margin
    CGFloat height = 0;
    for (NSInteger i = 0; i < self.layoutComponents.count; i++) {
        TangramLayoutComponent *component = self.layoutComponents[i];
        CGFloat maxMargin = MAX(last.margin.bottom, component.margin.top);
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - component.margin.left - component.margin.right;
        // 更新每一个item的高度
        for (NSInteger j = 0; j < component.itemInfos.count; j++) {
            id<TangramComponentDescriptor> item = component.itemInfos[j];
            CGFloat itemHeight = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]].height;
            item.expectedHeight = itemHeight;
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
    self.cacheHeight = height;
    _contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), _cacheHeight);
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
      
            if (CGRectIntersectsRect(descriptor.frame, rect) || component.pinnedType) {
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
    TangramLayoutComponent *layoutComponent = self.layoutComponents[indexPath.section];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = layoutComponent.itemInfos[indexPath.row].frame;
    if (layoutComponent.pinnedType) {
        CGFloat contentOffsetY = self.collectionView.contentOffset.y + 64;
        if (attributes.frame.origin.y < contentOffsetY) {
            attributes.frame = CGRectMake(attributes.frame.origin.x, contentOffsetY, attributes.size.width, attributes.size.height);
        }
        attributes.zIndex = 5;
    }
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
    return YES;
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}



- (CGSize)collectionViewContentSize {
    return _contentSize;
}

@end
