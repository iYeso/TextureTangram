//
//  ColorWithInnerTextNode.m
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "ColorWithInnerTextNode.h"
#import "TangramNodeRegistry.h"

@interface ColorWithInnerTextNode()

@property (nonatomic, strong) ASTextNode *textNode;

@end

@implementation ColorWithInnerTextNode



// 你可以在load方法设置node和type的映射，也可以在别的地方批量设置以减少启动时间
+ (void)load {
    [TangramNodeRegistry registerClass:self forType:@"innerText"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _textNode = [ASTextNode new];
        [self addSubnode:_textNode];
    }
    return self;
}

- (void)setModel:(ColorWithInnerTextModel *)model {
    [super setModel:model];
    if (!model.text) {
        model.text = @"";
    }
    self.textNode.attributedText = [[NSAttributedString alloc] initWithString:model.text attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    self.backgroundColor = model.color;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.textNode];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 5, 5, 5) child:center];
}

@end
