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

- (void)setModel:(ColorWithInnerTextInfo *)model {
    [super setModel:model];
    if (!model.text) {
        model.text = @"";
    }
    self.textNode.attributedText = [[NSAttributedString alloc] initWithString:model.text attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    self.backgroundColor = model.color;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.textNode];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:self.model.insets child:center];
}

@end
