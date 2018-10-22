//
//  TangramDefaultDataSourceHelper.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramDefaultDataSourceHelper.h"
#import "TangramBuildInLayout.h"
#import "NSArray+TangramParse.h"


@implementation TangramDefaultDataSourceHelper

- (NSMutableArray<TangramLayoutComponent *> *)layoutComponentsForContents:(NSArray *)contents {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:contents.count];
    @try {
        TangramLayoutComponent *component;
        for (NSDictionary *info in contents) {
            if ([info[@"type"] isEqualToString:@"component-banner"]) { //轮播
                component = TangramCarouselInlineLayoutComponent.new;
                [self setCarousel:(TangramCarouselInlineLayoutComponent*)component withInfo:info];
            }
            else if ([info[@"type"] isEqualToString:@"container-onePlusN"]) { //一拖2/3/4
                component = TangramOnePlusLayoutComponent.new;
                [self setOnePlus:(TangramOnePlusLayoutComponent*)component withInfo:info];
            }
            else if ([info[@"type"] isEqualToString:@"container-float"]) { //浮标
                
            }
            else if ([info[@"type"] isEqualToString:@"container-fix"]) { //固定顶部或者底部，根据属性指定
                
            }
            else if ([info[@"type"] isEqualToString:@"container-sticky"]) { //吸顶布局
//                BOOL enableScroll = [info[@"style"][@"enableScroll"] boolValue];
                component = TangramHorizontalInlineLayoutComponent.new;
                component.pinnedType = TangramLayoutComponentPinnedTypeTop;
                [self setComponent:component withInfo:info];
            }
            else if ([info[@"type"] isEqualToString:@"container-scrollFix"]) { //滚动固定(滚动到某个布局的时候，出现并固定)
                
            }
            else if ([info[@"type"] isEqualToString:@"container-oneColumn"]) { //网格1列
                component = TangramGridLayoutComponet.new;
                [self setGrid:(TangramGridLayoutComponet*)component withInfo:info columnNumber:1];
            }
            else if ([info[@"type"] isEqualToString:@"container-twoColumn"]) { //网格2列
                component = TangramGridLayoutComponet.new;
                [self setGrid:(TangramGridLayoutComponet*)component withInfo:info columnNumber:2];
            }
            else if ([info[@"type"] isEqualToString:@"container-threeColumn"]) { //网格3列
                component = TangramGridLayoutComponet.new;
                [self setGrid:(TangramGridLayoutComponet*)component withInfo:info columnNumber:3];
            }
            else if ([info[@"type"] isEqualToString:@"container-fourColumn"]) { //网格4列
                component = TangramGridLayoutComponet.new;
                [self setGrid:(TangramGridLayoutComponet*)component withInfo:info columnNumber:4];
            }
            else if ([info[@"type"] isEqualToString:@"container-fiveColumn"]) { //网格5列
                component = TangramGridLayoutComponet.new;
                [self setGrid:(TangramGridLayoutComponet*)component withInfo:info columnNumber:5];
            }
            else if ([info[@"type"] isEqualToString:@"container-scroll"]) { //线性滚动，不像轮播一样具有一页一页的效果
                component = TangramHorizontalInlineLayoutComponent.new;
                [self setHorizontalScrol:(TangramHorizontalInlineLayoutComponent*)component withInfo:info];
            }
            else if ([info[@"type"] isEqualToString:@"container-waterfall"]) { //瀑布流
                component = TangramCarouselInlineLayoutComponent.new;
                [self setSwiper:(TangramCarouselInlineLayoutComponent*)component withInfo:info];
            }
            
            [array addObject:component];
        }
    } @catch(NSException *e) {
        NSLog(@"Json存在问题 %@", e);
    } @finally {
        return array;
    }
}

- (void)setComponent:(TangramLayoutComponent *)component withInfo:(NSDictionary *)info {
    NSDictionary *style = info[@"style"];
    component.margin = [style[@"margin"] parseInsets];
    component.insets = [style[@"padding"] parseInsets];
    component.backgroundColor = style[@"bgColor"];
    component.backgroundImageURL = style[@"bgImgUrl"];
    
}

- (void)setCarousel:(TangramCarouselInlineLayoutComponent *)component withInfo:(NSDictionary *)info {
    [self setComponent:component withInfo:info];
    NSDictionary *style = info[@"style"];
    component.itemRatio = [style[@"itemRatio"] doubleValue];
    component.pageRatio = [style[@"pageRatio"] doubleValue];

    component.indicatorGravity = style[@"indicatorGravity"];
    component.indicatorPosition = style[@"indicatorPosition"];
    component.indicatorGap = [style[@"indicatorGap"] doubleValue];
    component.indicatorMargin  = [style[@"indicatorMargin"] doubleValue];
    component.indicatorHeight = [style[@"indicatorHeight"] doubleValue];
    component.scrollMarginLeft = [style[@"scrollMarginLeft"] doubleValue];
    component.scrollMarginRight = [style[@"scrollMarginRight"] doubleValue];
    component.hGap = [style[@"hGap"] doubleValue];
    component.autoScroll = [style[@"autoScroll"] unsignedIntegerValue];
    component.specialInterval = style[@"specialInterval"];
    component.infinite = [style[@"infinite"] boolValue];
    component.indicatorImg1 = style[@"indicatorImg1"];
    component.indicatorImg2 = style[@"indicatorImg2"];
}

- (void)setOnePlus:(TangramOnePlusLayoutComponent *)component withInfo:(NSDictionary *)info {
    [self setComponent:component withInfo:info];
    NSDictionary *style = info[@"style"];
    component.aspectRatio = [style[@"aspectRatio"] doubleValue];
    component.rowPartitions = style[@"rows"];
    component.cols = style[@"cols"];
}

- (void)setGrid:(TangramGridLayoutComponet *)component withInfo:(NSDictionary *)info columnNumber:(NSUInteger)column {
    [self setComponent:component withInfo:info];
    NSDictionary *style = info[@"style"];
    component.maximumColumn = column;
    component.rowAspectRatio = [style[@"aspectRatio"] doubleValue];
    component.verticalInterItemsSpace = [style[@"vGap"] doubleValue];
    component.horizontalInterItemsSpace = [style[@"hGap"] doubleValue];
    component.columnPartitions = style[@"cols"];
}

- (void)setHorizontalScrol:(TangramHorizontalInlineLayoutComponent *)component withInfo:(NSDictionary *)info {
    [self setComponent:component withInfo:info];
    NSDictionary *style = info[@"style"];
    component.pageWidth = [style[@"pageWidth"] doubleValue];
    component.pageHeight = [style[@"pageHeight"] doubleValue];
    component.scrollMarginLeft = [style[@"scrollMarginLeft"] doubleValue];
    component.scrollMarginLeft = [style[@"scrollMarginLeft"] doubleValue];
    component.hasIndicator = [style[@"hasIndicator"] boolValue];
    component.horizontalInterItemsSpace = [style[@"hGap"] doubleValue];
}

- (void)setSwiper:(TangramCarouselInlineLayoutComponent *)component withInfo:(NSDictionary *)info {
    [self setComponent:component withInfo:info];
    NSDictionary *style = info[@"style"];
    component.itemRatio = [style[@"itemRatio"] doubleValue];
    component.pageRatio = [style[@"pageRatio"] doubleValue];
    component.autoScroll = [style[@"autoScroll"] doubleValue];
    component.specialInterval = style[@"specialInterval"];
    component.infinite = [style[@"infinite"] doubleValue];
    component.indicatorImg1 = style[@"indicatorImg1"];
    component.indicatorImg2 = style[@"indicatorImg2"];
    component.indicatorGravity = style[@"indicatorGravity"];
    component.indicatorPosition = style[@"indicatorPosition"];
    component.indicatorGap = [style[@"indicatorGap"] doubleValue];
    component.indicatorMargin = [style[@"indicatorMargin"] doubleValue];
    component.indicatorHeight = [style[@"indicatorHeight"] doubleValue];
    component.scrollMarginLeft = [style[@"scrollMarginLeft"] doubleValue];
    component.scrollMarginRight = [style[@"scrollMarginRight"] doubleValue];
    component.horizontalInterItemsSpace = [style[@"hGap"] doubleValue];
}

@end
