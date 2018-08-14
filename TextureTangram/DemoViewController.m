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
//    UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.sectionHeadersPinToVisibleBounds = YES;
//    layout.sectionFootersPinToVisibleBounds = NO;
//    layout.sectionInset = UIEdgeInsetsZero;
    
    TangramGridLayoutComponet *gridLayout = [[TangramGridLayoutComponet alloc] init];
    gridLayout.maximumColumn = 3;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 100; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    gridLayout.itemInfos = array.copy;
    TangramCollectionViewLayout *collectionViewLayout = TangramCollectionViewLayout.new;
    collectionViewLayout.layoutComponents = @[gridLayout];
    
    self.layoutComponents = collectionViewLayout.layoutComponents;
    
    TangramLayoutComponent *last = nil; // 上一个布局，用来计算最大margin
    CGFloat height = 0;
    for (NSInteger i = 0; i < self.layoutComponents.count; i++) {
        TangramLayoutComponent *component = self.layoutComponents[i];
        CGFloat maxMargin = MAX(last.margin.bottom, component.margin.top);
        component.width = CGRectGetWidth(UIScreen.mainScreen.bounds) - component.margin.left - component.margin.right;
        component.layoutOrigin = CGPointMake(component.margin.left, last.layoutOrigin.y + last.height + maxMargin);
        CGFloat computeHeight = [component computeLayouts];
        last = component;
        height += computeHeight;
    }
    collectionViewLayout.cacheHeight = height;
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:collectionViewLayout];
    _collectionNode = collectionNode;
    if (self = [super initWithNode:collectionNode]) {
        [self setupNodes];
    }
    return self;
}

- (void)setupNodes {
    _collectionNode.backgroundColor = UIColor.whiteColor;
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
}

#pragma mark -  ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return 100;
}


- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode * _Nonnull(void) {
        ColorfulCellNode *node = [[ColorfulCellNode alloc] init];
        return node;
    };
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(self.layoutComponents[indexPath.section].itemInfos[indexPath.row].frame.size);
}


@end
