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
#import "ColorfulModel.h"
#import "ColorfulCellNode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    
    TangramNode *tan = TangramNode.new;

    // **************   测试数据  *****************8
    NSMutableArray<ColorfulModel*> *array;
    // 1 + N
    TangramOnePlusLayoutComponent *onePlus = [[TangramOnePlusLayoutComponent alloc] init];
    onePlus.rowPartitions = @[@4,@5];
    array = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 4; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    array[1].canvasHeight = 60;
    array[0].canvasHeight = 280;
    onePlus.margin = UIEdgeInsetsMake(30, 10, 30, 10);
    onePlus.itemInfos = array.copy;
    
    // 3列网格
    TangramGridLayoutComponet *threeColumn = [[TangramGridLayoutComponet alloc] init];
    threeColumn.maximumColumn = 3;
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 10; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    threeColumn.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    threeColumn.margin = UIEdgeInsetsMake(10, 0, 100, 0);
    threeColumn.columnPartitions = @[@1,@1,@1];
    threeColumn.horizontalInterItemsSpace = 8;
    threeColumn.verticalInterItemsSpace = 8;
    threeColumn.itemInfos = array.copy;
    
    
    // 双列网格
    TangramGridLayoutComponet *twoColumn = [[TangramGridLayoutComponet alloc] init];
    twoColumn.maximumColumn = 2;
    array = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < 8; i++) {
        ColorfulModel *m = [ColorfulModel new];
        [array addObject:m];
    }
    twoColumn.verticalInterItemsSpace = 20;
    twoColumn.itemInfos = array.copy;
    twoColumn.columnPartitions = @[@5,@4];
    twoColumn.horizontalInterItemsSpace = 20;
    twoColumn.margin = UIEdgeInsetsMake(100, 8, 30, 8);
    
    // sticky
    TangramGridLayoutComponet *sticky = [[TangramGridLayoutComponet alloc] init];
    sticky.maximumColumn = 1;
    array = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 1; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.canvasHeight = 50;
        [array addObject:m];
    }
    sticky.margin = UIEdgeInsetsMake(50, 0, 0, 0);
    sticky.columnPartitions = @[@1];
    sticky.itemInfos = array.copy;
    sticky.pinnedType = TangramLayoutComponentPinnedTypeTop;
    
    // 瀑布流
    TangramWaterFlowLayoutComponent *water = [[TangramWaterFlowLayoutComponent alloc] init];
    water.maximumColumn = 3;
    NSInteger itemCount = 15; //打开实时刷新， iPhone 5S 的瓶颈是3000个item（CPU100%)。不打开的话，10000个item的内存创建需要耗时10秒左右，不会卡顿; 现在采用直接stickyView添加到scrollView的做法，避免重新layout的开销
    array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        ColorfulModel *m = [ColorfulModel new];
        m.randomHeight = YES;
        [array addObject:m];
    }
    water.verticalInterItemsSpace = 8;
    water.horizontalInterItemsSpace = 15;
    water.itemInfos = array.copy;
    water.margin = UIEdgeInsetsMake(30, 8, 0, 8);
    NSArray *components = @[onePlus, threeColumn, twoColumn, sticky, water];
    
    
    tan.layoutComponents = components;
    ASViewController *viewController = [[ASViewController alloc] initWithNode:tan];
    ASNavigationController *nav = [[ASNavigationController alloc] initWithRootViewController:viewController];
    keyWindow.rootViewController = nav;
    [keyWindow makeKeyAndVisible];
    self.window = keyWindow;
    return YES;
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
