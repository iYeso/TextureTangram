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
