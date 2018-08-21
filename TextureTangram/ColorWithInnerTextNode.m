//
//  ColorWithInnerTextNode.m
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "ColorWithInnerTextNode.h"
#import "TangramNodeRegistry.h"

@implementation ColorWithInnerTextNode

// 你可以在load方法设置node和type的映射，也可以在别的地方批量设置以减少启动时间
+ (void)load {
    [TangramNodeRegistry registerClass:self forType:@"innerText"];
}

@end
