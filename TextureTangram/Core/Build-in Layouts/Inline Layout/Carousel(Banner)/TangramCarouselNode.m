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

#import "TangramCarouselNode.h"
#import "TangramPageControl.h"
#import "TangramCarouselInlineLayoutComponent.h"
#import "NSObject+SafeKVO.h"

@interface TangramCarouselNode()

@property (nonatomic, strong) TangramInlineCellInfo *model;
@property (nonatomic, strong) TangramPageControl *pageControl;
@end

@implementation TangramCarouselNode


- (void)setModel:(TangramInlineCellInfo *)model {
    [super setModel:model];
    TangramCarouselInlineLayoutComponent *component = (TangramCarouselInlineLayoutComponent *)model.layoutComponent;
    component.pageNode = self.pageNode;
    self.pageNode.delegate = component;
    self.pageNode.dataSource = component;
    self.pageControl = [[TangramPageControl alloc] initWithItemImageURL:@"https://img.alicdn.com/tps/TB16i4qNXXXXXbBXFXXXXXXXXXX-32-4.png" highlightedImageURL:@"https://img.alicdn.com/tps/TB1XRNFNXXXXXXKXXXXXXXXXXXX-32-4.png" interItemSpace:5 itemCount:component.itemInfos.count];
    component.pageControl = self.pageControl;
    [self addSubnode:self.pageControl];
}

- (TangramInlineCellInfo *)model {
    return (TangramInlineCellInfo *)[super model];
}


- (instancetype)init {
    if (self = [super init]) {
        self.pageNode = [[ASPagerNode alloc] init];
        [self addSubnode:self.pageNode];
    }
    
    return self;
}

- (void)didLoad {
    [super didLoad];
    self.pageNode.showsHorizontalScrollIndicator = NO;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec *insets = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 5, 5, 5) child:self.pageControl];
    
    // 相对父视图位置布局（比如中下方，中左方等等）
    ASRelativeLayoutSpec *rel = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionCenter verticalPosition:ASRelativeLayoutSpecPositionEnd sizingOption:ASRelativeLayoutSpecSizingOptionMinimumSize child:insets];
    
    
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:rel overlay:self.pageNode];
}

@end
