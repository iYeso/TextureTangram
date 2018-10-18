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

#import "TangramPageControl.h"

@interface TangramPageControl()

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *highlightedImageURL;
@property (nonatomic) CGFloat interItemSpace;
@property (nonatomic) NSUInteger itemCount;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation TangramPageControl

- (instancetype)initWithItemImageURL:(NSString *)imageURL highlightedImageURL:(NSString *)highlightedImageURL interItemSpace:(CGFloat)interItemSpace itemCount:(NSUInteger)itemCount {
    self = [self init];
    if (self) {
        _imageURL = imageURL;
        _highlightedImageURL = highlightedImageURL;
        _interItemSpace = interItemSpace;
        _itemCount = itemCount;
        _items = [NSMutableArray arrayWithCapacity:_itemCount];
        for (NSInteger i = 0; i < _itemCount; i++) {
            ASNetworkImageNode *iNode = [[ASNetworkImageNode alloc] init];
            iNode.backgroundColor = UIColor.lightGrayColor;
            if (imageURL) {
                iNode.URL = [NSURL URLWithString:imageURL];
            }
            [_items addObject:iNode];
            [self addSubnode:iNode];
        }
        self.currentIndex = 0;
    }
    return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSInteger i = 0;
    for (ASNetworkImageNode *iNode in self.items) {
        if (_imageURL && _highlightedImageURL) {
            iNode.URL = [NSURL URLWithString:currentIndex==i?_highlightedImageURL:_imageURL];
        }
        i++;
        [self addSubnode:iNode];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSMutableArray *fixItems = [NSMutableArray arrayWithCapacity:_itemCount];
    // 截取分别率
    NSArray *components = [_imageURL componentsSeparatedByString:@"-"];
    if (components.count < 2) {
        return ASLayoutSpec.new;
    }
    CGFloat height = [components.lastObject doubleValue];
    CGFloat width = [components[components.count-2] doubleValue];
    for (ASNetworkImageNode *node in self.items) {
        node.style.preferredSize = CGSizeMake(width, height);
        [fixItems addObject:node];
    }
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:self.interItemSpace justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:fixItems];
}

@end
