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

#import "TangramNode.h"
#import "TangramCollectionViewLayout.h"
#import "TangramGridLayoutComponet.h"
#import "TangramWaterFlowLayoutComponent.h"
#import "TangramOnePlusLayoutComponent.h"
#import "TangramItemNode.h"
#import "TangramNodeRegistry.h"

@interface TangramNode () <ASCollectionDelegate, ASCollectionDataSource, ASCollectionViewLayoutInspecting>

@property (nonatomic, strong) TangramCollectionViewLayout *collectionLayout;
@property (nonatomic, strong) NSLock *simpleLock;

@end

// 这个node可以看做一个中间层，用来计算布局，接收重新布局的信号，刷新数据的信号；注册nodetype于id对应;待完善这个中间层

@implementation TangramNode

- (instancetype)init {

    if (self = [super init]) {

        TangramCollectionViewLayout *collectionViewLayout = TangramCollectionViewLayout.new;
        self.collectionLayout = collectionViewLayout;
        
        ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:collectionViewLayout];
        collectionViewLayout.collectionNode = collectionNode;
        _collectionNode = collectionNode;
        [self addSubnode:_collectionNode];
        [self setupNodes];
    }
    
    // 预计算高度并不能利用collectionNode的优势
    // 不过与计算这些信息都可以放在异步线程，从某种程度来讲更具优势
    // 目前有所取舍： 使用CollectionNode自带的高度计算，那么需要在prepareLayout（主线程）里面重新设置高度。
    
    return self;
}

- (void)setupNodes {
    _simpleLock = [[NSLock alloc] init];
    _collectionNode.backgroundColor = UIColor.whiteColor;
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    _collectionNode.layoutInspector = self;
    self.backgroundColor = UIColor.whiteColor;
}

- (void)didLoad {
    [super didLoad];
}


- (void)setLayoutComponents:(NSArray<TangramLayoutComponent *> *)layoutComponents {
    _layoutComponents = layoutComponents.copy;
    self.collectionLayout.layoutComponents = layoutComponents;
    [self.collectionNode reloadData];

}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.collectionNode]];
}



#pragma mark - ASCollectionDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL isLegalIndex = self.collectionLayout.stickyIndex.integerValue >= 0 && self.collectionLayout.stickyIndex.integerValue < self.collectionLayout.layoutComponents.count;
    if (isLegalIndex) {
        [self.collectionLayout layouStickyNode];
    }
    
}


- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item at section:%@, row:%@", @(indexPath.section), @(indexPath.row));
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramComponentDescriptor * layoutDescriptor = self.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row];
    if (layoutDescriptor.expectedHeight > 0) { //已经计算好高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, layoutDescriptor.expectedHeight));
    } else { //尚未计算高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, 0),
                               CGSizeMake(layoutDescriptor.width, CGFLOAT_MAX));
    }
}
#pragma mark -  ASCollectionDataSource


- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return self.collectionLayout.layoutComponents.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.collectionLayout.layoutComponents[section].itemInfos.count;
}


- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:TangramCollectionViewSupplementaryKindHeader]) {
        return [self nodeBlockWithModel:self.collectionLayout.layoutComponents[indexPath.section].headerInfo];
    } else if ([kind isEqualToString:TangramCollectionViewSupplementaryKindFooter]) {
        return [self nodeBlockWithModel:self.collectionLayout.layoutComponents[indexPath.section].footerInfo];
        
    } else {
        return nil;
    }
}

/**
 * Asks the data source to provide a context object for the given section. This object
 * can later be retrieved by calling @c contextForSection: and is useful when implementing
 * custom @c UICollectionViewLayout subclasses. The context object is ret
 *
 * @param collectionNode The sender.
 * @param section The index of the section to provide context for.
 *
 * @return A context object to assign to the given section, or @c nil.
 */
- (nullable id<ASSectionContext>)collectionNode:(ASCollectionNode *)collectionNode contextForSection:(NSInteger)section {
    TangramLayoutComponent *component =  self.collectionLayout.layoutComponents[section];
    component.collectionView = collectionNode.view;
    return component;
}

- (NSArray<NSString *> *)collectionNode:(ASCollectionNode *)collectionNode supplementaryElementKindsInSection:(NSInteger)section {

    return @[TangramCollectionViewSupplementaryKindHeader, TangramCollectionViewSupplementaryKindFooter];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramComponentDescriptor *model = self.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row];
    return [self nodeBlockWithModel:model];
}


- (BOOL)shouldBatchFetchForCollectionNode:(ASCollectionNode *)collectionNode {
    return YES;
}


- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if ([self.delegate respondsToSelector:@selector(tangramNode:willBeginBatchFetchWithContext:)]) {
        [self.delegate tangramNode:self willBeginBatchFetchWithContext:context];
    } else {
        [context cancelBatchFetching];
    }
}

#pragma mark - ASCollectionViewLayoutInspecting

/**
 * Asks the inspector to provide a constrained size range for the given collection view node.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionNode:self.collectionNode constrainedSizeForItemAtIndexPath:indexPath];
}
#pragma clang diagnostic pop


/**
 * Return the directions in which your collection view can scroll
 */
- (ASScrollDirection)scrollableDirections {
    return ASScrollDirectionUp|ASScrollDirectionDown;
}


/**
 * Asks the inspector to provide a constrained size range for the given supplementary node.
 */
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TangramComponentDescriptor *info = nil;
    if ([kind isEqualToString:TangramCollectionViewSupplementaryKindHeader]) {
        info = self.collectionLayout.layoutComponents[indexPath.section].headerInfo;
    } else if ([kind isEqualToString:TangramCollectionViewSupplementaryKindFooter]) {
        info = self.collectionLayout.layoutComponents[indexPath.section].footerInfo;
    } else {
        return ASSizeRangeZero;
    }
    
    if (info.expectedHeight > 0) {
        return ASSizeRangeMake(CGSizeMake(info.width, info.expectedHeight));
    } else if (![info.class isSubclassOfClass:TangramItemNode.class]) {
        return ASSizeRangeMake(CGSizeMake(0.1, 0.1));
    }  else {
        return ASSizeRangeMake(CGSizeMake(info.width, 0),
                               CGSizeMake(info.width, CGFLOAT_MAX));
    }
    
    
}

/**
 * Asks the inspector for the number of supplementary views for the given kind in the specified section.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section {
    ASSizeRange constraint = [self collectionView:collectionView constrainedSizeForSupplementaryNodeOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
     return (constraint.max.height > 0 ? 1 : 0);
}


- (void)lock {
     [_simpleLock lock];
}

- (void)unlock {
    [_simpleLock unlock];
}

#pragma mark - helper method

- (ASCellNodeBlock)nodeBlockWithModel:(TangramComponentDescriptor *)model {
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
