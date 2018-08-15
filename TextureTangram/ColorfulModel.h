//
//  ColorfulModel.h
//  TextureTangram
//
//  Created by cello on 2018/8/14.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TangramComponentDescriptor.h"

@interface ColorfulModel : NSObject <TangramComponentDescriptor>

@property (nonatomic, copy) NSString *type; ///< UI组件的类型

@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat expectedHeight; //如果想高度固定，可以重写getter返回一个固定高度

@end
