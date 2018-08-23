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
#import "TangramItemNode.h"
#import "TangramNodeRegistry.h"
#import "TangramInlineLayoutComponent.h"
#import "TangramInlineCellModel.h"

@interface TangramNode () <ASCollectionDelegate, ASCollectionDataSource, ASCollectionViewLayoutInspecting>

@property (nonatomic, strong) TangramCollectionViewLayout *collectionLayout;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

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
    _semaphore = dispatch_semaphore_create(1);
    _collectionNode.backgroundColor = UIColor.whiteColor;
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    _collectionNode.layoutInspector = self;
    self.backgroundColor = UIColor.whiteColor;
    
    [TangramNodeRegistry registerClass:TangramItemNode.class forType:@"placeholder"];
    [TangramNodeRegistry registerClass:TangramItemNode.class forType:@"horizontal"];
}

// 类似controller的 viewDidLoad
- (void)didLoad {
    [super didLoad];
}


// 设置了数据源需要重新布局
- (void)setLayoutComponents:(NSArray<TangramLayoutComponent *> *)layoutComponents {
    _layoutComponents = layoutComponents.copy;
    self.collectionLayout.layoutComponents = layoutComponents;
    [self.collectionNode reloadData];
}


// 返回一个绝对布局，tangramNode包了一层collectionNode
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.collectionNode]];
}



#pragma mark - ASCollectionDelegate

// 更新stickyNode的状态。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL isLegalIndex = self.collectionLayout.stickyIndex.integerValue >= 0 && self.collectionLayout.stickyIndex.integerValue < self.collectionLayout.layoutComponents.count;
    if (isLegalIndex) {
        [self.collectionLayout layouStickyNode];
    }
}


//TODO: 把这个点击事件抛出去
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item at section:%@, row:%@", @(indexPath.section), @(indexPath.row));
}

// ASDK的node是异步加载的，当加载完毕时，直接使用计算好的高度。
// 还有一种情况，就是高度是预先指定的，那么，在这里可以直接使用指定的高度，而不是让ASDK去计算
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TangramLayoutComponent *component = self.collectionLayout.layoutComponents[indexPath.section];
    if (component.isInlineLayout) {
        TangramInlineLayoutComponent *inlineLayoutComponent = (TangramInlineLayoutComponent*)component;
        if (CGRectEqualToRect(CGRectZero, inlineLayoutComponent.inlineCellFrame)) {
            return ASSizeRangeUnconstrained;
        } else {
            return ASSizeRangeMake(inlineLayoutComponent.inlineCellFrame.size);
        }
    }
    TangramItemInfo * layoutDescriptor = component.itemInfos[indexPath.row];
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
    TangramLayoutComponent *component = self.collectionLayout.layoutComponents[section];
    if (component.isInlineLayout) {
        return 1;
    } else {
        return component.itemInfos.count;
    }
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
    TangramLayoutComponent *component = self.collectionLayout.layoutComponents[indexPath.section];
    TangramItemInfo *model;
    if (!component.isInlineLayout) {
        model = component.itemInfos[indexPath.row];
    } else {
        // 内联布局特殊处理
        model = [(TangramInlineLayoutComponent *)component inlineModel];
    }
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
#pragma clang diagnostic ignored "-Wall"
///FIXME: 这里的警告不知道怎么消掉。原因是dataSource 也有一个constrainedSizeForNodeAtIndexPath方法，而我只是想
///实现ASCollectionViewLayoutInspecting里面的方法
/// 创建另外一个遵循ASCollectionViewLayoutInspecting协议的类似乎很多余
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
    TangramItemInfo *info = nil;
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
        return ASSizeRangeMake(CGSizeMake(0.1, 0.1)); //高度不设为一个大于0的值会崩溃（摊手）
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
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)unlock {
    dispatch_semaphore_signal(_semaphore);
}

#pragma mark - helper method

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
