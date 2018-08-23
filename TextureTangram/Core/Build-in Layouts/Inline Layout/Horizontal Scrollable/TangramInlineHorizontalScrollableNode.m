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


#import "TangramInlineHorizontalScrollableNode.h"
#import "TangramHorizontalInlineLayoutComponent.h"
#import "TangramInlineCellModel.h"

@interface TangramInlineHorizontalScrollableNode()

@property (nonatomic, strong) TangramInlineCellModel *model;

@end

@implementation TangramInlineHorizontalScrollableNode


- (void)setModel:(TangramInlineCellModel *)model {
    [super setModel:model];
    TangramHorizontalInlineLayoutComponent *component = (TangramHorizontalInlineLayoutComponent *)model.layoutComponent;
    component.collectionNode = self.collectionNode;
    self.collectionNode.delegate = component;
    self.collectionNode.dataSource = component;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionNode.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = component.horizontalInterItemsSpace;
//    [self.collectionNode reloadData];
}

- (TangramInlineCellModel *)model {
    return (TangramInlineCellModel*)[super model];
}


- (instancetype)init {
    if (self = [super init]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        [self addSubnode:self.collectionNode];
        self.collectionNode.backgroundColor = UIColor.lightGrayColor;
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.collectionNode]];
}

@end
