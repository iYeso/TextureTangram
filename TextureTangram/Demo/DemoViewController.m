//
//  DemoViewController.m
//  TextureTangram
//
//  Created by cello on 2018/8/23.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "DemoViewController.h"
#import "TangramNode.h"
#import "TangramCollectionViewLayout.h"
#import "TangramGridLayoutComponet.h"
#import "TangramWaterFlowLayoutComponent.h"
#import "TangramOnePlusLayoutComponent.h"
#import "TangramHorizontalInlineLayoutComponent.h"
#import "ColorfulNodeInfo.h"
#import "ColorfulCellNode.h"
#import "ColorWithInnerTextInfo.h"
#import "TangramCarouselInlineLayoutComponent.h"

#define RANDOM_FLOAT_VALUE ((arc4random()%1001)/1000.0)
#define RANDOM_COLOR [UIColor colorWithRed:RANDOM_FLOAT_VALUE green:RANDOM_FLOAT_VALUE blue:RANDOM_FLOAT_VALUE alpha:1.0]

@interface DemoViewController ()

@property (nonatomic,strong) TangramNode *tangramNode;

@end

@implementation DemoViewController

- (instancetype)init{
    TangramNode *tan = TangramNode.new;
    _tangramNode = tan;
    self = [super initWithNode:tan];
    if (self) {
        [self setupNodes];
        [self setupNavitaionItems];
    }
    return self;
}

- (void)setupNodes {
    
    // **************   测试数据  *****************8
    NSMutableArray<TangramComponentDescriptor*> *array;
    // 1 + N
    TangramOnePlusLayoutComponent *onePlus = [[TangramOnePlusLayoutComponent alloc] init];
    onePlus.sectionName = @"1+N";
    onePlus.rowPartitions = @[@4,@5];
    array = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 4; i++) {
        ColorWithInnerTextInfo *m = [ColorWithInnerTextInfo new];
        m.color = RANDOM_COLOR;
        m.text = [NSString stringWithFormat:@"1+N Part %d", (int)i];
        [array addObject:m];
    }
    
    array[0].expectedHeight = 280;
    onePlus.margin = UIEdgeInsetsMake(30, 10, 30, 10);
    onePlus.itemInfos = array.copy;
    ColorWithInnerTextInfo *onePlusHeaderInfo = [ColorWithInnerTextInfo new];;
    onePlusHeaderInfo.expectedHeight = 60;
    onePlusHeaderInfo.text = @"1+N Header";
    onePlusHeaderInfo.color = RANDOM_COLOR;
    onePlus.headerInfo = onePlusHeaderInfo;
    ColorWithInnerTextInfo *onePlusFooterInfo = [ColorWithInnerTextInfo new];;
    onePlusFooterInfo.expectedHeight = 60;
    onePlusFooterInfo.text = @"1+N Footer";
    onePlusFooterInfo.color = RANDOM_COLOR;
    onePlus.footerInfo = onePlusFooterInfo;
    
    
    // 3列网格
    TangramGridLayoutComponet *threeColumn = [[TangramGridLayoutComponet alloc] init];
    threeColumn.sectionName = @"3 columns";
    threeColumn.maximumColumn = 3;
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 9; i++) {
        ColorfulNodeInfo *m = [ColorfulNodeInfo new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 150;
        [array addObject:m];
    }
    threeColumn.insets = UIEdgeInsetsMake(15, 10, 15, 10);
    threeColumn.margin = UIEdgeInsetsMake(10, 0, 50, 0);
    threeColumn.columnPartitions = @[@1,@1,@1];
    threeColumn.horizontalInterItemsSpace = 8;
    threeColumn.verticalInterItemsSpace = 8;
    threeColumn.itemInfos = array.copy;
    ColorWithInnerTextInfo *threeColumnHeaderInfo = [ColorWithInnerTextInfo new];;
    threeColumnHeaderInfo.expectedHeight = 60;
    threeColumnHeaderInfo.text = @"3 columns Header";
    threeColumnHeaderInfo.color = RANDOM_COLOR;
    threeColumn.headerInfo = threeColumnHeaderInfo;
    ColorWithInnerTextInfo *threeColumnFooterInfo = [ColorWithInnerTextInfo new];;
    threeColumnFooterInfo.expectedHeight = 60;
    threeColumnFooterInfo.text = @"3 columns Footer";
    threeColumnFooterInfo.color = RANDOM_COLOR;
    threeColumn.footerInfo = threeColumnFooterInfo;
    
    // 横向滑动
    TangramHorizontalInlineLayoutComponent *horizontal = [[TangramHorizontalInlineLayoutComponent alloc] init];
    horizontal.sectionName = @"Horizontal";
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulNodeInfo *m = [ColorfulNodeInfo new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 100;
        [array addObject:m];
    }
    horizontal.itemInfos = array.copy;
    horizontal.horizontalInterItemsSpace = 20;
    horizontal.margin = UIEdgeInsetsMake(10, 0, 10, 0);
    horizontal.fixHeight = 250; //内联的布局需要指定高度
    horizontal.scrollMarginRight = 100;
    horizontal.scrollMarginLeft = 10;
    
    // banner
    TangramCarouselInlineLayoutComponent *banner = [[TangramCarouselInlineLayoutComponent alloc] init];
    banner.sectionName = @"banner";
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 5; i++) {
        ColorWithInnerTextInfo *m = [ColorWithInnerTextInfo new];
        m.color = RANDOM_COLOR;
        m.text = [NSString stringWithFormat:@"我很帅%ld", i];
        [array addObject:m];
    }
    banner.itemInfos = array.copy;
    banner.margin = UIEdgeInsetsMake(10, 0, 10, 0);
    banner.fixHeight = 250; //内联的布局需要指定高度
    
    
    // 双列网格
    TangramGridLayoutComponet *twoColumn = [[TangramGridLayoutComponet alloc] init];
    twoColumn.sectionName = @"2 columns";
    twoColumn.maximumColumn = 2;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulNodeInfo *m = [ColorfulNodeInfo new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 120;
        [array addObject:m];
    }
    twoColumn.verticalInterItemsSpace = 20;
    twoColumn.itemInfos = array.copy;
    twoColumn.columnPartitions = @[@5,@4];
    twoColumn.horizontalInterItemsSpace = 20;
    twoColumn.margin = UIEdgeInsetsMake(40, 8, 30, 8);
    
    // sticky
    //FIXME:吸顶布局只支持一个cell；不能设置header、footer
    // 可以选择用内联布局
    TangramHorizontalInlineLayoutComponent *sticky = [[TangramHorizontalInlineLayoutComponent alloc] init];
    sticky.sectionName = @"Sticky";
    sticky.fixHeight = 100; //stikcy目前只能固定高度
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 5; i++) {
        ColorWithInnerTextInfo *m = [ColorWithInnerTextInfo new];
        m.color = RANDOM_COLOR;
        m.expectedHeight = 60;
        m.text = @"Sticky Node";
        [array addObject:m];
    }
    sticky.margin = UIEdgeInsetsMake(50, 0, 0, 0);
    sticky.itemInfos = array.copy;
    sticky.pinnedType = TangramLayoutComponentPinnedTypeTop;
    
    // 瀑布流
    TangramWaterFlowLayoutComponent *water = [[TangramWaterFlowLayoutComponent alloc] init];
    water.sectionName = @"waterfull";
    water.maximumColumn = 3;
    NSInteger itemCount = 15; //打开实时刷新， iPhone 5S 的瓶颈是3000个item（CPU100%)。不打开的话，10000个item的内存创建需要耗时10秒左右，不会卡顿; 现在采用直接stickyView添加到scrollView的做法，避免重新layout的开销
    array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        ColorfulNodeInfo *m = [ColorfulNodeInfo new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 170+arc4random()%80;
        [array addObject:m];
    }
    water.verticalInterItemsSpace = 8;
    water.horizontalInterItemsSpace = 15;
    water.itemInfos = array.copy;
    water.margin = UIEdgeInsetsMake(30, 8, 50, 8);
    water.insets = UIEdgeInsetsMake(10, 0, 10, 0);
    ColorWithInnerTextInfo *waterHeaderInfo = [ColorWithInnerTextInfo new];;
    waterHeaderInfo.expectedHeight = 60;
    waterHeaderInfo.text = @"waterfull Header";
    waterHeaderInfo.color = RANDOM_COLOR;
    water.headerInfo = waterHeaderInfo;
    ColorWithInnerTextInfo *waterFooterInfo = [ColorWithInnerTextInfo new];;
    waterFooterInfo.expectedHeight = 60;
    waterFooterInfo.text = @"waterfull Footer";
    waterFooterInfo.color = RANDOM_COLOR;
    water.footerInfo = waterFooterInfo;
    
    NSArray *components = @[banner,onePlus,horizontal, sticky, threeColumn, twoColumn, water];
    _tangramNode.layoutComponents = components;
}

- (void)setupNavitaionItems {
    // 删除操作
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(removeFirst)];
    self.navigationItem.rightBarButtonItem = deleteItem;
    // 添加操作
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addItemsToGridLayout)];
    self.navigationItem.leftBarButtonItem = addItem;
}

#pragma mark - events
- (void)removeFirst {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tangramNode.layoutComponents];
    [array removeObjectAtIndex:0];
    self.tangramNode.layoutComponents = array.copy;
    [self.tangramNode.collectionNode relayoutItems];
}

- (void)addItemsToGridLayout {
    NSInteger index = 0;
    BOOL found = NO;
    for (TangramGridLayoutComponet *obj in self.tangramNode.layoutComponents) {
        if([obj isKindOfClass:[TangramGridLayoutComponet class]] && obj.pinnedType == TangramLayoutComponentPinnedTypeNone) {
            found = YES;
            break;
        }
        index++;
    }
    if (!found) {
        return;
    }
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.tangramNode.collectionNode performBatchUpdates:^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.tangramNode.layoutComponents[index].itemInfos];
        self.tangramNode.layoutComponents[index].itemInfos = array;
        
        
        NSInteger originalCount = array.count;
        // 插入100个操作耗时： 当前如果需要展示刚插入的node，会耗时6ms左右，如果还不需要展示，耗时1ms内。
        // 所以最好事先 batch update 操作（预加载）
        for (NSInteger i = originalCount; i < originalCount+3; i++) {
            ColorfulNodeInfo *m = [ColorfulNodeInfo new];
            m.color = RANDOM_COLOR;
            m.canvasHeight = 150;
            [array addObject:m];
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
        [self.tangramNode.collectionNode insertItemsAtIndexPaths:indexPaths];
        
    } completion:^(BOOL finished) {
        CFTimeInterval start = CFAbsoluteTimeGetCurrent();
        [self.tangramNode.collectionNode reloadItemsAtIndexPaths:indexPaths];
        //不需要整个collectionNode刷新，不然耗时很多
        //        [self.tangramNode.collectionNode relayoutItems];
        NSLog(@"插入的layout耗时 %.2fms", (CFAbsoluteTimeGetCurrent()-start)*1000);
    }];
    
}

@end
