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

#import "TangramViewController.h"
#import "TangramCollectionViewLayout.h"
#import "TangramGridLayoutComponet.h"
#import "TangramWaterFlowLayoutComponent.h"
#import "TangramOnePlusLayoutComponent.h"
#import "ColorfulModel.h"
#import "ColorfulCellNode.h"

@interface TangramViewController () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSArray<TangramLayoutComponent *> *layoutComponents;
@end

// 这个controller可以看做一个中间层，用来计算布局，接收重新布局的信号，刷新数据的信号；注册nodetype于id对应;待完善这个中间层
@implementation TangramViewController

- (instancetype)init {
    
    // 测试数据（本不应该放在这儿。等开发完毕就挪到别的地方）
    
    // 3列网格
    TangramGridLayoutComponet *threeColumn = [[TangramGridLayoutComponet alloc] init];
    threeColumn.maximumColumn = 3;
    NSMutableArray<ColorfulModel*> *array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 10; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    threeColumn.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    threeColumn.margin = UIEdgeInsetsMake(10, 0, 100, 0);
    threeColumn.columnPartitions = @[@1,@1,@1];
    threeColumn.horizontalInterItemsSpace = 8;
    threeColumn.verticalInterItemsSpace = 8;
    threeColumn.itemInfos = array.copy;
    
    // 双列网格
    TangramGridLayoutComponet *twoColumn = [[TangramGridLayoutComponet alloc] init];
    twoColumn.maximumColumn = 2;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    twoColumn.verticalInterItemsSpace = 20;
    twoColumn.itemInfos = array.copy;
    twoColumn.columnPartitions = @[@5,@4];
    twoColumn.horizontalInterItemsSpace = 20;
    twoColumn.margin = UIEdgeInsetsMake(100, 8, 30, 8);
    
    // 1 + N
    TangramOnePlusLayoutComponent *onePlus = [[TangramOnePlusLayoutComponent alloc] init];
    onePlus.rowPartitions = @[@4,@5];
    array = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 4; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    array[1].canvasHeight = 60;
    array[0].canvasHeight = 280;
    onePlus.itemInfos = array.copy;
    
    // 瀑布流
    TangramWaterFlowLayoutComponent *water = [[TangramWaterFlowLayoutComponent alloc] init];
    water.maximumColumn = 3;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 21; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.randomHeight = YES;
        [array addObject:m];
    }
    water.verticalInterItemsSpace = 8;
    water.horizontalInterItemsSpace = 15;
    water.itemInfos = array.copy;
    water.margin = UIEdgeInsetsMake(30, 8, 0, 8);
    
    
    //  设置布局组件
    TangramCollectionViewLayout *collectionViewLayout = TangramCollectionViewLayout.new;
    collectionViewLayout.layoutComponents = @[threeColumn, twoColumn, onePlus ,water];
    self.layoutComponents = collectionViewLayout.layoutComponents;
    
    
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:collectionViewLayout];
    _collectionNode = collectionNode;
    if (self = [super initWithNode:collectionNode]) {
        [self setupNodes];
    }
    
    // 预计算高度并不能利用collectionNode的优势
    // 不过与计算这些信息都可以放在异步线程，从某种程度来讲更具优势
    // 目前有所取舍： 使用CollectionNode自带的高度计算，那么需要在prepareLayout（主线程）里面重新设置高度。
    // 后续把layout计算放在异步看有没有可能
    return self;
}

- (void)setupNodes {
    _collectionNode.backgroundColor = UIColor.whiteColor;
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
}

#pragma mark - ASCollectionDelegate

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item at section:%@, row:%@", @(indexPath.section), @(indexPath.row));
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<TangramComponentDescriptor> layoutDescriptor = self.layoutComponents[indexPath.section].itemInfos[indexPath.row];
    if (layoutDescriptor.expectedHeight > 0) { //已经计算好高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, layoutDescriptor.expectedHeight));
    } else { //尚未计算高度
        return ASSizeRangeMake(CGSizeMake(layoutDescriptor.width, 0),
                               CGSizeMake(layoutDescriptor.width, CGFLOAT_MAX));
    }
}
#pragma mark -  ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return self.layoutComponents.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.layoutComponents[section].itemInfos.count;
}


- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    return ^ASCellNode * _Nonnull(void) {
        typeof(weakSelf) sself = weakSelf;
        ColorfulCellNode *node = [[ColorfulCellNode alloc] init];
        node.model = sself.layoutComponents[indexPath.section].itemInfos[indexPath.row];
        return node;
    };
}



@end
