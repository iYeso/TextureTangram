//
//  TangramLayoutComponent.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/13.
//  Copyright © 2018年 ZZinKin. All rights reserved.
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

@property (nonatomic) CGPoint layoutOrigin; ///< 布局的起点
@property (nonatomic) CGFloat width; ///< 布局宽度 

@property (nonatomic) UIEdgeInsets margin; ///< layout的外边距会控制background、header的范围； margin
@property (nonatomic) UIEdgeInsets insets; ///< layout的内边距，控制items与header、footer之间的边距；对应padding

@property (nonatomic) BOOL isFloatingLayout; ///< 是否为固定布局/浮动布局; 不应该放到TangramCollectionViewLayout里面参与布局计算
@property (nonatomic) TangramLayoutComponentPinnedType pinnedType; ///< 是否有吸顶/吸底效果
@property (nonatomic) CGFloat height;  ///< 整个布局的高度；调用computeLayoutsWithOrigin会改变此属性
/// 整个layout的头部描述信息，布局在items上方
@property (nonatomic, strong, nullable) TangramComponentDescriptor *headerInfo;
/// 整个layout尾部信息，布局在items下方
@property (nonatomic, strong, nullable) TangramComponentDescriptor *footerInfo;

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
