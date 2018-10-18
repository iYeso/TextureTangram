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

#import "TangramCarouselInlineLayoutComponent.h"
#import "TangramNodeRegistry.h"
#import "TangramCarouselNode.h"
#import "NSTimer+Compatible.h"
NSInteger numberOfLoopsInTangramCarousel = 100;

@interface TangramCarouselInlineLayoutComponent()

@property (nonatomic) NSTimeInterval autoScrollInterval;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger dataIndex;

@end

@implementation TangramCarouselInlineLayoutComponent

NSString *TangramCarouselNodeType = @"carousel";

+ (void)load {
    [TangramNodeRegistry registerClass:TangramCarouselNode.class forType:TangramCarouselNodeType];
}

- (NSString *)type {
    return TangramCarouselNodeType;
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

- (void)recalculateIndex:(NSInteger)index {
    if (self.infinite)  {
        self.dataIndex = (index%numberOfLoopsInTangramCarousel)%self.itemInfos.count;
    } else {
        self.dataIndex = index;
    }
    self.pageControl.currentIndex = self.dataIndex;
}

#pragma mark - timer

- (void)setupTimer  {
    [self recalculateIndex: self.pageNode.currentPageIndex];
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        typeof(weakSelf) sself = weakSelf;
        if (sself == nil) { return;}
        NSInteger nextPageIndex = sself.pageNode.currentPageIndex+1;
        if (sself.infinite) {
            nextPageIndex = nextPageIndex%(sself.itemInfos.count*numberOfLoopsInTangramCarousel);
        } else {
            nextPageIndex = nextPageIndex % sself.itemInfos.count;
        }
        [sself.pageNode scrollToPageAtIndex:nextPageIndex animated:YES];
        [sself recalculateIndex:nextPageIndex];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - setter

- (void)setPageNode:(ASPagerNode *)pageNode {
    _pageNode = pageNode;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self adjustPositionIfNeeded];
    });
}


- (void)setAutoScroll:(NSInteger)autoScroll {
    _autoScroll = autoScroll;
    if (autoScroll > 0) {
        _autoScrollInterval = autoScroll/1000.0;
        [self setupTimer];
    } else {
        _autoScrollInterval = 0;
        [self invalidateTimer];
    }
}

#pragma mark - override

- (instancetype)init {
    self = [super init];
    if (self) {
        _infinite = YES;
    }
    return self;
}

#pragma mark - collectionNode delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_autoScroll > 0) {
        [self setupTimer];
    }
}

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    if (self.itemInfos.count == 1 || !self.infinite) {
        return self.itemInfos.count;
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
