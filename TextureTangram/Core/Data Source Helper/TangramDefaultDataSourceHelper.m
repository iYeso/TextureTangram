//
//  TangramDefaultDataSourceHelper.m
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/19.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import "TangramDefaultDataSourceHelper.h"
#import "TangramBuildInLayout.h"

@implementation TangramDefaultDataSourceHelper

- (NSMutableArray<TangramLayoutComponent *> *)layoutComponentsForContents:(NSArray *)contents {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:contents.count];
    for (NSDictionary *component in contents) {
        if ([component[@"type"] isEqualToString:@"component-banner"]) {
            
        } else if ([component[@"type"] isEqualToString:@"container-onePlusN"]) {
            
        }
        else if ([component[@"type"] isEqualToString:@"container-oneColumn"]) {
            
        }
        else if ([component[@"type"] isEqualToString:@"container-container-twoColumn"]) {
            
        }
        else if ([component[@"type"] isEqualToString:@"container-oneColumn"]) {
            
        }
        else if ([component[@"type"] isEqualToString:@"container-oneColumn"]) {
            
        }
    }
    return array;
}


@end
