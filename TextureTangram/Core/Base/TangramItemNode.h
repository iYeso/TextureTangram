//
//  TangramItemNode.h
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TangramComponentDescriptor.h"

@interface TangramItemNode : ASCellNode

@property (nonatomic, strong) TangramComponentDescriptor *model;

@end
