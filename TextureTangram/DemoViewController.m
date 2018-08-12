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

@interface DemoViewController () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation DemoViewController

- (instancetype)init {
    // 使用系统的flowlayout无法实现整个section的背景以及装饰
//    UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.sectionHeadersPinToVisibleBounds = YES;
//    layout.sectionFootersPinToVisibleBounds = NO;
//    layout.sectionInset = UIEdgeInsetsZero;
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:TangramCollectionViewLayout.new];
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

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return 1000;
}


- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = [[ASCellNode alloc] init];
    node.backgroundColor = [UIColor grayColor];
    return node;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(CGSizeMake(100, 100));
}

@end
