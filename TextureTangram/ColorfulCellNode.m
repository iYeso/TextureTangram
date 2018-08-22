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
//

#import "ColorfulCellNode.h"
#import "ColorfulModel.h"
#import "TangramNodeRegistry.h"


@interface ColorfulCellNode()

@property (nonatomic, strong) ColorfulModel *model;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) ASDisplayNode *canvas;
@property (nonatomic, strong) ASTextNode *redLabel;
@property (nonatomic, strong) ASTextNode *greenLabel;
@property (nonatomic, strong) ASTextNode *blueLabel;

@end

@implementation ColorfulCellNode

+ (void)load {
    [TangramNodeRegistry registerClass:self forType:@"colorful"];
}

#pragma mark - setters and getters

- (ColorfulModel *)model {
    return (ColorfulModel *)[super model];
}

- (void)setModel:(ColorfulModel *)model {
    [super setModel:model];
    self.color = model.color;
}


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
    self.canvas.style.height = ASDimensionMake(self.model.canvasHeight);
    ASStackLayoutSpec *stackMain = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.canvas, self.redLabel, self.greenLabel, self.blueLabel]];
    return stackMain;
}

@end
