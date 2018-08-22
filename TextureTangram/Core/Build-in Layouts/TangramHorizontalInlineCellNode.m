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


#import "TangramHorizontalInlineCellNode.h"
#import "TangramHorizontalLayoutComponent.h"
#import "TangramHorizontalInlineCellModel.h"
#import "TangramNodeRegistry.h"

@interface TangramHorizontalInlineCellNode()

@property (nonatomic, strong) TangramHorizontalInlineCellModel *model;

@end

@implementation TangramHorizontalInlineCellNode

+ (void)load {
    [TangramNodeRegistry registerClass:self forType:TangramHorizontalInlineCellType];
}

- (void)setModel:(TangramHorizontalInlineCellModel *)model {
    [super setModel:model];
    model.layoutComponent.collectionNode = self.collectionNode;
    self.collectionNode.delegate = model.layoutComponent;
    self.collectionNode.dataSource = model.layoutComponent;
    [self.collectionNode reloadData];
}

- (TangramHorizontalInlineCellModel *)model {
    return (TangramHorizontalInlineCellModel*)[super model];
}


- (instancetype)init {
    if (self = [super init]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    }
    return self;
}

@end
