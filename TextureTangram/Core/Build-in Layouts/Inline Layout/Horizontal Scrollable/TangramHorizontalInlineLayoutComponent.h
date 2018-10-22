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


#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TangramInlineLayoutComponent.h"
#import "TangramInlineCellInfo.h"


/// 内联布局，如banner、横向滑动等布局继承使用本布局
@interface TangramHorizontalInlineLayoutComponent : TangramInlineLayoutComponent < ASCollectionDataSource, ASCollectionDelegateFlowLayout>

- (ASCellNodeBlock)nodeBlockWithModel:(TangramComponentDescriptor *)model;
@property (nonatomic, weak) ASCollectionNode *collectionNode;


/**
 页面宽度，在iOS上配置了此参数，轮播布局的滚动会变为线性,不配置的话，就是一页一页的滚动，Android需要依赖此选型设置页面宽度
 注意： 暂时不支持
 */
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic) CGFloat pageHeight; ///< 页面高度
@property (nonatomic) BOOL hasIndicator; ///< 是否显示滚动指示
@property (nonatomic) CGFloat horizontalInterItemsSpace; ///< 垂直方向每个组件的距离; hGap
@property (nonatomic) CGFloat scrollMarginLeft; ///< 最左边一帧距离布局左边的间距
@property (nonatomic) CGFloat scrollMarginRight; ///<最右边一帧距离布局右边的间距
@property (nonatomic, strong) UIColor *indicatorColor; ///<指示器选中颜色(iOS不支持)
@property (nonatomic, strong) UIColor *defaultIndicatorColor; ///<指示器默认颜色(iOS不支持)
@end
