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
#import "TangramInlineLayoutComponent.h"
#import "TangramPageControl.h"

/// 滚动图布局
@interface TangramCarouselInlineLayoutComponent : TangramInlineLayoutComponent <ASPagerDataSource, ASPagerDelegate>

@property (nonatomic, weak) ASPagerNode *pageNode;

@property (nonatomic, weak) TangramPageControl *pageControl;
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
    自动滚动的间隔，单位毫秒，填写数字大于0就开始自动滚动，默认值0
 */
@property (nonatomic) NSInteger autoScroll;


/**
 指示器选中状态的图片，必须带图片宽高比后缀
 */
@property (nonatomic, copy) NSString *indicatorImg1;

/**ß
 指示器未被选中状态的图片，必须带图片宽高比后缀
 */
@property (nonatomic, copy) NSString *indicatorImg2;

/**
 指示器位置，居中居左还是居右;
 "left"/"right"/"center"
 */
@property (nonatomic, copy) NSString *indicatorGravity;

/**
 指示器位置，在内部还是在外部;
 默认内部，暂不支持外部；
 "inside"/"outside"
 */
@property (nonatomic, copy) NSString *indicatorPosition;

/**
 单独指定每一帧的自动滚动的间隔，单位毫秒，key从0开始计数；
 与autoScroll配合使用，当未在此声明某一帧的停留时间的时候，
 使用autoScroll指定的间隔，否则使用此处声明的间隔时间（暂时不支持）
 */
@property (nonatomic, strong) NSDictionary *specialInterval;

/**
 是否为无限滚动
 */
@property (nonatomic) BOOL infinite;

/**
 每个之间的指示器间距
 */
@property (nonatomic) CGFloat indicatorGap;

/**
 指示器相对于布局底端的间距
 */
@property (nonatomic) CGFloat indicatorMargin;

/**
 指示器高度（暂时不支持，似乎没必要）
 */
@property (nonatomic) CGFloat indicatorHeight;

/**
 最左边一帧距离布局左边的间距
 */
@property (nonatomic) CGFloat scrollMarginLeft;

/**
 最右边一帧距离布局右边的间距
 */
@property (nonatomic) CGFloat scrollMarginRight;

/**
 横向每一帧之间的间距 (暂不支持）
 */
@property (nonatomic) CGFloat hGap;

@end
