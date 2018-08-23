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

@interface TangramWaterFlowLayoutComponent : TangramLayoutComponent

@property (nonatomic) NSUInteger maximumColumn; ///< 最大列数，默认1
@property (nonatomic) CGFloat verticalInterItemsSpace; ///< 垂直方向每个组件的间距；vGap
@property (nonatomic) CGFloat horizontalInterItemsSpace; ///< 垂直方向每个组件的距离; hGap

@end
