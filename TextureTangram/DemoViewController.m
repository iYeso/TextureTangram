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

#import "DemoViewController.h"
#import "TangramCollectionViewLayout.h"
#import "TangramGridLayoutComponet.h"
#import "ColorfulModel.h"
#import "ColorfulCellNode.h"

@interface DemoViewController () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSArray<TangramLayoutComponent *> *layoutComponents;
@end

// 这个controller可以看做一个中间层，用来计算布局，接收重新布局的信号，刷新数据的信号；注册nodetype于id对应;待完善这个中间层
@implementation DemoViewController

- (instancetype)init {
    // 使用系统的flowlayout无法实现整个section的背景以及装饰
//    FlowLayout *layout = FlowLayout.new;
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.sectionHeadersPinToVisibleBounds = YES;
//    layout.sectionFootersPinToVisibleBounds = NO;
//    layout.sectionInset = UIEdgeInsetsZero;
    
    // 测试数据
    
    // 3列网格
    TangramGridLayoutComponet *threeColumn = [[TangramGridLayoutComponet alloc] init];
    threeColumn.maximumColumn = 3;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 50; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    threeColumn.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    threeColumn.margin = UIEdgeInsetsMake(20, 0, 20, 0);
    threeColumn.horizontalInterItemsSpace = 8;
    threeColumn.verticalInterItemsSpace = 8;
    threeColumn.itemInfos = array.copy;
    
    // 双列网格
    TangramGridLayoutComponet *twoColumn = [[TangramGridLayoutComponet alloc] init];
    twoColumn.maximumColumn = 2;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 50; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    twoColumn.verticalInterItemsSpace = 20;
    twoColumn.itemInfos = array.copy;
    twoColumn.margin = UIEdgeInsetsMake(100, 8, 30, 8);
    
    TangramCollectionViewLayout *collectionViewLayout = TangramCollectionViewLayout.new;
    collectionViewLayout.layoutComponents = @[threeColumn, twoColumn];
    
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
    return ^ASCellNode * _Nonnull(void) {
        ColorfulCellNode *node = [[ColorfulCellNode alloc] init];
        return node;
    };
}



@end
