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

@implementation TangramItemNode

// 这个方法需要重写（不要调用super），当没有设置header、footer的时候，返回一个sizeZero作为placeholder
// 有点tricky
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.style.preferredSize = CGSizeMake(0.1, 0.1);
    return [[ASLayoutSpec alloc] init];
}

@end
