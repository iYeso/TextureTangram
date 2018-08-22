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

#import "ColorWithInnerTextModel.h"

@implementation ColorWithInnerTextModel

// 本应该由json设置
- (NSString *)type {
    return @"innerText";
}

- (CGFloat)computeHeightWithWidth:(CGFloat)width {
    return self.expectedHeight > 0?self.expectedHeight:60;
}

@end
