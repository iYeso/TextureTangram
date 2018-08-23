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


#import "TangramComponentDescriptor.h"

@class TangramInlineLayoutComponent;
/// 内联滑动一个横向的collectionNode的模型，由于TangramComponentDescriptor不是协议类型，所以需要一层包装
@interface TangramInlineCellModel : TangramComponentDescriptor

@property (nonatomic, weak) TangramInlineLayoutComponent *layoutComponent;

@end
