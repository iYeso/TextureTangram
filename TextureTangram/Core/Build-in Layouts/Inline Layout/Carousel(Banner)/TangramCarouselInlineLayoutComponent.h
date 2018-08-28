//
//  TangramCarouselInlineLayoutComponent.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/28.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TangramInlineLayoutComponent.h"

/// 滚动图布局
@interface TangramCarouselInlineLayoutComponent : TangramInlineLayoutComponent <ASPagerDataSource, ASPagerDelegate>

@property (nonatomic, weak) ASPagerNode *pageNode;

/**
 页之间的间距
 */
@property (nonatomic) CGFloat horizontalInterItemsSpace;

/**
 内部 View 的宽高比，宽度按满屏幕根据ratio计算高度，
 建议设置此属性，可预先占位，避免 Banner 有一个高度撑开的过程
 */
@property (nonatomic) CGFloat itemRatio;

/**
 内部 View 宽度占总屏幕宽度的比例，如内部 View 宽度为 120，屏幕宽为750，
 则此值是 120/750=0.16
 */
@property (nonatomic) CGFloat pageRatio;

/**
    自动滚动的间隔，单位秒（这里与文档不同，但json里面仍然填毫秒），填写数字大于0就开始自动滚动，默认值0
 */
@property (nonatomic) NSTimeInterval autoScroll;


/**
 单独指定每一帧的自动滚动的间隔，单位毫秒，key从0开始计数；
 与autoScroll配合使用，当未在此声明某一帧的停留时间的时候，
 使用autoScroll指定的间隔，否则使用此处声明的间隔时间
 */
@property (nonatomic, strong) NSDictionary *specialInterval;

/**
 是否为无限滚动
 */
@property (nonatomic) BOOL infinite;

@end
