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
            BOOL isGrid = NO;
            NSInteger gridColumnNumber = 1;
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
            else if ([info[@"type"] isEqualToString:@"container-scrollFix"]) { //滚动固定(滚动到某个布局的时候，出现并固定)
                
            }
            else if ([info[@"type"] isEqualToString:@"container-oneColumn"]) { //网格1列
                isGrid = YES;
            }
            else if ([info[@"type"] isEqualToString:@"container-twoColumn"]) { //网格2列
                isGrid = YES;
                gridColumnNumber = 2;
            }
            else if ([info[@"type"] isEqualToString:@"container-threeColumn"]) { //网格3列
                isGrid = YES;
                gridColumnNumber = 3;
            }
            else if ([info[@"type"] isEqualToString:@"container-fourColumn"]) { //网格4列
                isGrid = YES;
                gridColumnNumber = 4;
            }
            else if ([info[@"type"] isEqualToString:@"container-fiveColumn"]) { //网格5列
                isGrid = YES;
                gridColumnNumber = 5;
            }
            else if ([info[@"type"] isEqualToString:@"container-scroll"]) { //线性滚动，不像轮播一样具有一页一页的效果
                
            }
            else if ([info[@"type"] isEqualToString:@"container-waterfall"]) { //瀑布流
                
            }
            
            
            
            if (isGrid) {
                //网格布局单独控制
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
    NSDictionary *style = info[@"style"];
    component.aspectRatio = [style[@"aspectRatio"] doubleValue];
    component.rowPartitions = style[@"rows"];
}
        



@end
