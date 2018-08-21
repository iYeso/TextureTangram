//
//  ColorWithInnerTextModel.h
//  TextureTangram
//
//  Created by cello on 2018/8/21.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramComponentDescriptor.h"

@interface ColorWithInnerTextModel: TangramComponentDescriptor

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *color;

@end
