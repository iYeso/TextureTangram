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

@interface TangramPageControl : ASDisplayNode

/**
 创建一个页码指示器的实例

 @param imageURL 正常状态的图片地址（后面拼接比例）
 @param highlightedImageURL 高亮状态的图片地址（后面拼接比例）
 @param interItemSpace pageCtrl标识点之间的间距
 @param itemCount 标识点的数目
 */
- (instancetype)initWithItemImageURL:(NSString *)imageURL
                 highlightedImageURL:(NSString *)highlightedImageURL
                      interItemSpace:(CGFloat)interItemSpace
                           itemCount:(NSUInteger)itemCount;

@property (nonatomic) NSInteger currentIndex;

@end
