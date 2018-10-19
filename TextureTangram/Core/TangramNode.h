/// Copyright ZZinKin
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


#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TangramLayoutComponent.h"

@class TangramNode;
@protocol TangramNodeDelegate<NSObject>

@optional
- (void)tangramNode:(TangramNode *)tangram willBeginBatchFetchWithContext:(ASBatchContext *)context;

@end

@interface TangramNode : ASDisplayNode


/**
 数据源；如果用不可变的数组会有问题
 */
@property (nonatomic, strong) NSMutableArray<TangramLayoutComponent *> *layoutComponents;

/**
 流式布局的collectionView
 */
@property (nonatomic, strong) ASCollectionNode *collectionNode;

@property (nonatomic, weak) id<TangramNodeDelegate> delegate;


// 插入、删除操作见demo

@end

