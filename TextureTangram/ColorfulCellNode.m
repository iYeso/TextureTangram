//
//  ColorfulCellNode.m
//  LearnTexture
//
//  Created by 廖超龙 on 2018/8/3.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "ColorfulCellNode.h"

#define RANDOM_FLOAT_VALUE ((arc4random()%1001)/1000.0)

@interface ColorfulCellNode()

@property (nonatomic, strong) ASDisplayNode *canvas;
@property (nonatomic, strong) ASTextNode *redLabel;
@property (nonatomic, strong) ASTextNode *greenLabel;
@property (nonatomic, strong) ASTextNode *blueLabel;

@end

@implementation ColorfulCellNode

#pragma mark - setters and getters

- (instancetype)init {
    if (self = [super init]) {
        //init方法是在主线程之外的线程执行，可以完成一些耗时操作
        _canvas = [ASDisplayNode new];
        _redLabel = [ASTextNode new];
        _greenLabel = [ASTextNode new];
        _blueLabel = [ASTextNode new];
        [self addSubnode:_canvas];
        [self addSubnode:_redLabel];
        [self addSubnode:_greenLabel];
        [self addSubnode:_blueLabel];
        [self setColor:[UIColor colorWithRed:RANDOM_FLOAT_VALUE green:RANDOM_FLOAT_VALUE blue:RANDOM_FLOAT_VALUE alpha:1.0]];
    }
    return self;
}


- (void)setColor:(UIColor *)color {
    if (color != _color) {
        _color = [color copy];
        self.canvas.backgroundColor = _color;
        CGFloat red,green,blue,alpha;
    
        [_color getRed:&red green:&green blue:&blue alpha:&alpha];
        self.redLabel.attributedText = [self attributedStringWithColorName:@"red" value:red];
        self.blueLabel.attributedText = [self attributedStringWithColorName:@"blue" value:blue];
        self.greenLabel.attributedText = [self attributedStringWithColorName:@"green" value:green];
    }
}
- (NSAttributedString *)attributedStringWithColorName:(NSString *)colorName value:(CGFloat)value {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %.2f", colorName, value] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:15]}];
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.canvas.style.height = ASDimensionMake(60+arc4random()%60);
    ASStackLayoutSpec *stackMain = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.canvas, self.redLabel, self.greenLabel, self.blueLabel]];
    return stackMain;
}

@end
