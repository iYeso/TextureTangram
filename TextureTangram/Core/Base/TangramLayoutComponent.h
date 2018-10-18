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
#import "TangramComponentDescriptor.h"
#import <AsyncDisplayKit/ASSectionContext.h>
NS_ASSUME_NONNULL_BEGIN

/** 类似tableView header吸顶、footer吸底的效果 */
typedef NS_ENUM(NSUInteger, TangramLayoutComponentPinnedType) {
    TangramLayoutComponentPinnedTypeNone = 0, ///< 正常布局
    TangramLayoutComponentPinnedTypeTop, ///< 吸顶；目前只支持一个吸顶布局
    TangramLayoutComponentPinnedTypeBottom, ///< 吸底，目前没有实现
};

/**
 对应tangram的内置布局；类似collectionView的section
 添加一种layout类型需要继承它
 */
@interface TangramLayoutComponent : NSObject <ASSectionContext>

@property CGPoint layoutOrigin; ///< 布局的起点
@property CGFloat width; ///< 布局宽度
@property BOOL isInlineLayout; ///<是否为内联布局
@property UIEdgeInsets margin; ///< layout的外边距会控制background、header的范围； margin
@property UIEdgeInsets insets; ///< layout的内边距，控制items与header、footer之间的边距；对应padding

@property BOOL isFloatingLayout; ///< 是否为固定布局/浮动布局; 不应该放到TangramCollectionViewLayout里面参与布局计算
@property TangramLayoutComponentPinnedType pinnedType; ///< 是否有吸顶/吸底效果
@property CGFloat height;  ///< 整个布局的高度；调用computeLayoutsWithOrigin会改变此属性
@property (nonatomic) CGFloat fixHeight; ///< 设置大于0的值，调用height只能获取到fixHeight
/// 整个layout的头部描述信息，布局在items上方，不能为空
@property (nonatomic, strong, nonnull) TangramComponentDescriptor *headerInfo;
/// 整个layout尾部信息，布局在items下方，不能为空
@property (nonatomic, strong, nonnull) TangramComponentDescriptor *footerInfo;

@property (nonatomic, strong, nullable) TangramComponentDescriptor *backgroundInfo;
/// 背景图片地址
@property (nonatomic, strong, nullable) NSString *backgroundImageURL;
/// 背景颜色
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

///  布局项，对应cell
@property (nonatomic, strong, nonnull)  NSArray<TangramComponentDescriptor*> *itemInfos;
@property (nonatomic) UIEdgeInsets edgeInsets;  ///< 整个layout的边距；需要注意附近的layout也可能会设置

/**
 * Custom name of this section, for debugging only.
 */
@property (nonatomic, copy, nullable) NSString *sectionName;
@property (nonatomic, weak, nullable) ASCollectionView *collectionView;


/**
 重写此方法重新计算布局；得到的高度信息会缓存到height属性
 */
- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width;

@end

 NS_ASSUME_NONNULL_END
