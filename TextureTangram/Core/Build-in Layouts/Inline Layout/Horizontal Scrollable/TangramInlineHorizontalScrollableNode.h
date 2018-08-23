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


#import "TangramItemNode.h"

/// 内联一个横向滑动的collectionNode，可以继承它用于扩展成banner
@interface TangramInlineHorizontalScrollableNode : TangramItemNode

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end
