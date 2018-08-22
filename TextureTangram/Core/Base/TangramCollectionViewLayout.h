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


#import <UIKit/UIKit.h>
#import "TangramLayoutComponent.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
extern NSString *const TangramCollectionViewBackgroundDecoratedKind;
extern NSString *const TangramCollectionViewSupplementaryKindHeader;
extern NSString *const TangramCollectionViewSupplementaryKindFooter;

/// 要是写自定义layout，直接调用 self.collectionView.delegate 来获取布局大小等等信息；
/// collectionNode 会使用 rangeController和DataController进行优化（但是有限）。先看看用flowlayout实现效果如何
@interface TangramCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat cacheHeight;
@property (nonatomic, strong) NSArray<TangramLayoutComponent *> *layoutComponents;
@property (nonatomic, weak) ASCollectionNode *collectionNode;
@property (nonatomic, strong) ASDisplayNode *stickyNode;
@property (nonatomic, strong, readonly) NSNumber *stickyIndex;
//@property (nonatomic, strong) NSMutableDictionary *cellAttributes;
//@property (nonatomic, strong) NSMutableDictionary *supplementaryViewAttributes;
//@property (nonatomic, strong) NSMutableDictionary *decoratedViewAttributes;

- (void)layouStickyNode;

@end
