//
//  TangramCarouselInlineLayoutComponent.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/28.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramCarouselInlineLayoutComponent.h"
#import "TangramNodeRegistry.h"
#import "TangramCarouselNode.h"
NSInteger numberOfLoopsInTangramCarousel = 100;

@interface TangramCarouselInlineLayoutComponent()


@end

@implementation TangramCarouselInlineLayoutComponent

NSString *TangramCarouselNodeType = @"carousel";

+ (void)load {
    [TangramNodeRegistry registerClass:TangramCarouselNode.class forType:TangramCarouselNodeType];
}

- (NSString *)type {
    return TangramCarouselNodeType;
}

- (void)setPageNode:(ASPagerNode *)pageNode {
    _pageNode = pageNode;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self adjustPositionIfNeeded];
    });
}

- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    [super computeLayoutsWithOrigin:origin width:width];
    // self.height不需要计算，由外部设置
    CGFloat headerHeight = CGRectGetHeight(self.headerInfo.frame);
    CGFloat footerHeight = self.footerInfo.expectedHeight;
    if ([self.footerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        footerHeight =[self.footerInfo computeHeightWithWidth:width];
    }
    self.inlineCellFrame = CGRectMake(origin.x+self.insets.left,
                                      origin.y + headerHeight + self.insets.top,
                                      width-self.insets.left-self.insets.right,
                                      self.height-self.insets.top-self.insets.right);
}


#pragma mark - override

- (instancetype)init {
    self = [super init];
    self.infinite = YES;
    return self;
}

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    if (self.itemInfos.count == 1 || !self.infinite) {
        return 1;
    } else if (self.itemInfos.count == 0) {
        return 0;
    } else {
        return numberOfLoopsInTangramCarousel*self.itemInfos.count;
    }
}
- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index {
    TangramComponentDescriptor *model = self.itemInfos[index%self.itemInfos.count];
    return [self nodeBlockWithModel:model];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(collectionNode.frame.size);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustPositionIfNeeded];
}

- (ASCellNodeBlock)nodeBlockWithModel:(TangramComponentDescriptor *)model {
    return ^ASCellNode * _Nonnull(void) {
        Class nodeClass = [TangramNodeRegistry classForType:model.type];
        if (!model || !nodeClass || ![nodeClass isSubclassOfClass:TangramItemNode.class]) {
            return [TangramItemNode new];
        }
        TangramItemNode *node = (TangramItemNode*)[[nodeClass alloc] init];
        node.model = model;
        return node;
    };
}

- (void)adjustPositionIfNeeded {
    if (self.infinite) {
        NSInteger index = lround(self.pageNode.contentOffset.x / self.pageNode.frame.size.width);
        NSInteger targetIndex = numberOfLoopsInTangramCarousel/2*self.itemInfos.count+index%self.itemInfos.count;
        [self.pageNode scrollToPageAtIndex:targetIndex animated:NO];
    }
}

@end
