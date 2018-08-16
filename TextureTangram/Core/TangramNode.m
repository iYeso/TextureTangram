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
#import "ColorfulModel.h"
#import "ColorfulCellNode.h"

@interface TangramNode () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) TangramCollectionViewLayout *collectionLayout;
@property (nonatomic, strong) ASCellNode *stickyNode;
@end

// 这个controller可以看做一个中间层，用来计算布局，接收重新布局的信号，刷新数据的信号；注册nodetype于id对应;待完善这个中间层
@implementation TangramNode

- (instancetype)init {

    if (self = [super init]) {
        //  设置布局组件
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
    _collectionNode.backgroundColor = UIColor.whiteColor;
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    _stickyNode = [ASCellNode new];
    _stickyNode.backgroundColor = UIColor.blueColor;
    [_collectionNode addSubnode:_stickyNode];
    _collectionLayout.stickyNode = _stickyNode;
    _stickyNode.hidden = YES;
    self.backgroundColor = UIColor.whiteColor;
}


- (void)setLayoutComponents:(NSArray<TangramLayoutComponent *> *)layoutComponents {
    _layoutComponents = layoutComponents;
    self.collectionLayout.layoutComponents = layoutComponents;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.collectionNode]];
}



#pragma mark - ASCollectionDelegate

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item at section:%@, row:%@", @(indexPath.section), @(indexPath.row));
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<TangramComponentDescriptor> layoutDescriptor = self.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row];
    if (layoutDescriptor.expectedHeight > 0) { //已经计算好高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, layoutDescriptor.expectedHeight));
    } else { //尚未计算高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, 0),
                               CGSizeMake(layoutDescriptor.width, CGFLOAT_MAX));
    }
}
#pragma mark -  ASCollectionDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL isLegalIndex = self.collectionLayout.stickyIndex.integerValue >= 0 && self.collectionLayout.stickyIndex.integerValue < self.collectionLayout.layoutComponents.count;
    if (isLegalIndex) {
        [self.collectionLayout layouStickyNode];
    }
    
    
}


- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return self.collectionLayout.layoutComponents.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.collectionLayout.layoutComponents[section].itemInfos.count;
}


- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (self.collectionLayout.stickyIndex==nil || indexPath.section != self.collectionLayout.stickyIndex.integerValue) {
        return ^ASCellNode * _Nonnull(void) {
            typeof(weakSelf) sself = weakSelf;
            ColorfulCellNode *node = [[ColorfulCellNode alloc] init];
            node.model = sself.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row];
            return node;
        };
    } else {
        return ^ASCellNode * _Nonnull(void) {
            typeof(weakSelf) sself = weakSelf;
            ASCellNode *cellNode = ASCellNode.new;
            // placeholder
            cellNode.style.height = ASDimensionMake(sself.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row].expectedHeight);
            return cellNode;
        };
    }
}



@end
