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

@property (nonatomic, copy) NSString *type;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat expectedHeight;

@end
