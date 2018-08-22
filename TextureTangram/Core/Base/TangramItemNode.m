//
//  TangramItemNode.m
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramItemNode.h"

@implementation TangramItemNode

// 这个方法需要重写（不要调用super），当没有设置header、footer的时候，返回一个sizeZero作为placeholder
// 有点tricky
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.style.preferredSize = CGSizeMake(0.1, 0.1);
    return [[ASLayoutSpec alloc] init];
}

@end
