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

#import "TangramLayoutComponent.h"

@interface TangramGridLayoutComponet : TangramLayoutComponent

@property (nonatomic) NSUInteger maximumColumn; ///< 最大列数，默认1
@property (nonatomic) double rowAspectRatio;  ///< 每一行宽高比； 对应aspectRatio
@property (nonatomic) CGFloat verticalInterItemsSpace; ///< 垂直方向每个组件的间距；vGap
@property (nonatomic) CGFloat horizontalInterItemsSpace; ///< 垂直方向每个组件的距离; hGap

///每列的百分比，如果是N列，可以只写Array中只写N-1项，最后一项会自动填充，如果加一起大于100，就按照填写的来算；示例：    ["30","30"] 或 [30",30]
@property (nonatomic) NSArray<NSNumber *> *columnPartitions;


@end
