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

#import "AppDelegate.h"
#import "TangramNode.h"
#import "TangramCollectionViewLayout.h"
#import "TangramGridLayoutComponet.h"
#import "TangramWaterFlowLayoutComponent.h"
#import "TangramOnePlusLayoutComponent.h"
#import "TangramHorizontalInlineLayoutComponent.h"
#import "ColorfulModel.h"
#import "ColorfulCellNode.h"
#import "ColorWithInnerTextModel.h"

@interface AppDelegate ()

@property (nonatomic,strong) TangramNode *tangramNode;

@end

@implementation AppDelegate

#define RANDOM_FLOAT_VALUE ((arc4random()%1001)/1000.0)
#define RANDOM_COLOR [UIColor colorWithRed:RANDOM_FLOAT_VALUE green:RANDOM_FLOAT_VALUE blue:RANDOM_FLOAT_VALUE alpha:1.0]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    // **************   测试数据  *****************8
    NSMutableArray<TangramComponentDescriptor*> *array;
    // 1 + N
    TangramOnePlusLayoutComponent *onePlus = [[TangramOnePlusLayoutComponent alloc] init];
    onePlus.sectionName = @"1+N";
    onePlus.rowPartitions = @[@4,@5];
    array = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 4; i++) {
        ColorWithInnerTextModel *m = [ColorWithInnerTextModel new];
        m.color = RANDOM_COLOR;
        m.text = [NSString stringWithFormat:@"1+N Part %d", (int)i];
        [array addObject:m];
    }
    
    array[0].expectedHeight = 280;
    onePlus.margin = UIEdgeInsetsMake(30, 10, 30, 10);
    onePlus.itemInfos = array.copy;
    ColorWithInnerTextModel *onePlusHeaderInfo = [ColorWithInnerTextModel new];;
    onePlusHeaderInfo.expectedHeight = 60;
    onePlusHeaderInfo.text = @"1+N Header";
    onePlusHeaderInfo.color = RANDOM_COLOR;
    onePlus.headerInfo = onePlusHeaderInfo;
    ColorWithInnerTextModel *onePlusFooterInfo = [ColorWithInnerTextModel new];;
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
        ColorfulModel *m = [ColorfulModel new];
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
    ColorWithInnerTextModel *threeColumnHeaderInfo = [ColorWithInnerTextModel new];;
    threeColumnHeaderInfo.expectedHeight = 60;
    threeColumnHeaderInfo.text = @"3 columns Header";
    threeColumnHeaderInfo.color = RANDOM_COLOR;
    threeColumn.headerInfo = threeColumnHeaderInfo;
    ColorWithInnerTextModel *threeColumnFooterInfo = [ColorWithInnerTextModel new];;
    threeColumnFooterInfo.expectedHeight = 60;
    threeColumnFooterInfo.text = @"3 columns Footer";
    threeColumnFooterInfo.color = RANDOM_COLOR;
    threeColumn.footerInfo = threeColumnFooterInfo;
    
    // 横向滑动
    TangramHorizontalInlineLayoutComponent *horizontal = [[TangramHorizontalInlineLayoutComponent alloc] init];
    horizontal.sectionName = @"Horizontal";
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 100;
        [array addObject:m];
    }
    horizontal.itemInfos = array.copy;
    horizontal.horizontalInterItemsSpace = 20;
    horizontal.margin = UIEdgeInsetsMake(10, 0, 10, 0);
    horizontal.height = 300;
    horizontal.scrollMarginRight = 100;
    horizontal.scrollMarginLeft = 10;
    

    // 双列网格
    TangramGridLayoutComponet *twoColumn = [[TangramGridLayoutComponet alloc] init];
    twoColumn.sectionName = @"2 columns";
    twoColumn.maximumColumn = 2;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulModel *m = [ColorfulModel new];
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
    TangramGridLayoutComponet *sticky = [[TangramGridLayoutComponet alloc] init];
    sticky.sectionName = @"Sticky";
    sticky.maximumColumn = 1;
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 1; i++) {
        
        ColorWithInnerTextModel *m = [ColorWithInnerTextModel new];
        m.color = RANDOM_COLOR;
        m.expectedHeight = 60;
        m.text = @"Sticky Node";
        [array addObject:m];
    }
    sticky.margin = UIEdgeInsetsMake(50, 0, 0, 0);
    sticky.columnPartitions = @[@1];
    sticky.itemInfos = array.copy;
    sticky.pinnedType = TangramLayoutComponentPinnedTypeTop;
    
    // 瀑布流
    TangramWaterFlowLayoutComponent *water = [[TangramWaterFlowLayoutComponent alloc] init];
    water.sectionName = @"waterfull";
    water.maximumColumn = 3;
    NSInteger itemCount = 15; //打开实时刷新， iPhone 5S 的瓶颈是3000个item（CPU100%)。不打开的话，10000个item的内存创建需要耗时10秒左右，不会卡顿; 现在采用直接stickyView添加到scrollView的做法，避免重新layout的开销
    array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.color = RANDOM_COLOR;
        m.canvasHeight = 170+arc4random()%80;
        [array addObject:m];
    }
    water.verticalInterItemsSpace = 8;
    water.horizontalInterItemsSpace = 15;
    water.itemInfos = array.copy;
    water.margin = UIEdgeInsetsMake(30, 8, 50, 8);
    water.insets = UIEdgeInsetsMake(10, 0, 10, 0);
    ColorWithInnerTextModel *waterHeaderInfo = [ColorWithInnerTextModel new];;
    waterHeaderInfo.expectedHeight = 60;
    waterHeaderInfo.text = @"waterfull Header";
    waterHeaderInfo.color = RANDOM_COLOR;
    water.headerInfo = waterHeaderInfo;
    ColorWithInnerTextModel *waterFooterInfo = [ColorWithInnerTextModel new];;
    waterFooterInfo.expectedHeight = 60;
    waterFooterInfo.text = @"waterfull Footer";
    waterFooterInfo.color = RANDOM_COLOR;
    water.footerInfo = waterFooterInfo;
    
    
    
    NSArray *components = @[onePlus,horizontal, sticky, threeColumn, twoColumn, water];
    
    TangramNode *tan = TangramNode.new;
    tan.layoutComponents = components;
    ASViewController *viewController = [[ASViewController alloc] initWithNode:tan];
    _tangramNode = tan;
    
    
    // 删除操作
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(removeFirst)];
    viewController.navigationItem.rightBarButtonItem = deleteItem;
    // 添加操作
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addItemsToSecondLayout)];
    viewController.navigationItem.leftBarButtonItem = addItem;
    ASNavigationController *nav = [[ASNavigationController alloc] initWithRootViewController:viewController];
    keyWindow.rootViewController = nav;
    [keyWindow makeKeyAndVisible];
    self.window = keyWindow;
    return YES;
}

- (void)removeFirst {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tangramNode.layoutComponents];
    [array removeObjectAtIndex:0];
    self.tangramNode.layoutComponents = array.copy;
    [self.tangramNode.collectionNode relayoutItems];
}

- (void)addItemsToSecondLayout {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.tangramNode.collectionNode performBatchUpdates:^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.tangramNode.layoutComponents[1].itemInfos];
        self.tangramNode.layoutComponents[1].itemInfos = array;
        
        
        NSInteger originalCount = array.count;
        // 插入100个操作耗时： 当前如果需要展示刚插入的node，会耗时6ms左右，如果还不需要展示，耗时1ms内。
        // 所以最好事先 batch update 操作（预加载）
        for (NSInteger i = originalCount; i < originalCount+6; i++) {
            ColorfulModel *m = [ColorfulModel new];
            m.color = RANDOM_COLOR;
            m.canvasHeight = 150;
            [array addObject:m];
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incdoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
