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
@property (nonatomic, strong) TangramCollectionViewLayout *collectionLayout;
@property (nonatomic, strong) NSNumber *stickyIndex;
@end

// 这个controller可以看做一个中间层，用来计算布局，接收重新布局的信号，刷新数据的信号；注册nodetype于id对应;待完善这个中间层
@implementation TangramViewController

- (instancetype)init {
    
    // 测试数据（本不应该放在这儿。等开发完毕就挪到别的地方）
    NSMutableArray<ColorfulModel*> *array;
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
    onePlus.margin = UIEdgeInsetsMake(30, 10, 30, 10);
    onePlus.itemInfos = array.copy;
    
    // 3列网格
    TangramGridLayoutComponet *threeColumn = [[TangramGridLayoutComponet alloc] init];
    threeColumn.maximumColumn = 3;
    array = [NSMutableArray arrayWithCapacity:50];
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
    
    // sticky
    TangramGridLayoutComponet *sticky = [[TangramGridLayoutComponet alloc] init];
    sticky.maximumColumn = 1;
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 1; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.canvasHeight = 50;
        [array addObject:m];
    }
    sticky.margin = UIEdgeInsetsMake(50, 0, 100, 0);
    sticky.columnPartitions = @[@1];
    sticky.itemInfos = array.copy;
    sticky.pinnedType = TangramLayoutComponentPinnedTypeTop;
    _stickyIndex = @(2);
    
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

    
    // 瀑布流
    TangramWaterFlowLayoutComponent *water = [[TangramWaterFlowLayoutComponent alloc] init];
    water.maximumColumn = 3;
    NSInteger itemCount = 3000; //打开实时刷新， iPhone 5S 的瓶颈是3000个item（CPU100%)。不打开的话，10000个item的内存创建需要耗时10秒左右，不会卡顿
    array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
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
    collectionViewLayout.layoutComponents = @[onePlus, threeColumn, sticky, twoColumn ,water];
    self.collectionLayout = collectionViewLayout;
    
    
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:collectionViewLayout];
    collectionViewLayout.collectionNode = collectionNode;
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

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return self.collectionLayout.layoutComponents.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.collectionLayout.layoutComponents[section].itemInfos.count;
}


- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (_stickyIndex==nil || indexPath.section != _stickyIndex.integerValue) {
        return ^ASCellNode * _Nonnull(void) {
            typeof(weakSelf) sself = weakSelf;
            ColorfulCellNode *node = [[ColorfulCellNode alloc] init];
            node.model = sself.collectionLayout.layoutComponents[indexPath.section].itemInfos[indexPath.row];
            return node;
        };
    } else {
        return ^ASCellNode * _Nonnull(void) {
            ASCellNode *cellNode = ASCellNode.new;
            cellNode.backgroundColor = UIColor.redColor;
            cellNode.style.minHeight = ASDimensionMake(50);
            return cellNode;
        };
    }
}



@end
