//
//  TangramCarouselNode.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/8/28.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramCarouselNode.h"
#import "TangramCarouselInlineLayoutComponent.h"

@interface TangramCarouselNode()

@property (nonatomic, strong) TangramInlineCellInfo *model;
@end

@implementation TangramCarouselNode


- (void)setModel:(TangramInlineCellInfo *)model {
    [super setModel:model];
    TangramCarouselInlineLayoutComponent *component = (TangramCarouselInlineLayoutComponent *)model.layoutComponent;
    component.pageNode = self.pageNode;
    self.pageNode.delegate = component;
    self.pageNode.dataSource = component;
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
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.pageNode]];
}

@end
