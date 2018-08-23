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

#import "TangramLayoutComponent.h"

@implementation TangramLayoutComponent

- (TangramComponentDescriptor *)headerInfo {
    if (!_headerInfo) {
        _headerInfo = TangramComponentDescriptor.new;
        _headerInfo.expectedHeight = 0;
    }
    return _headerInfo;
}

- (TangramComponentDescriptor *)footerInfo {
    if (!_footerInfo) {
        _footerInfo = TangramComponentDescriptor.new;
        _footerInfo.expectedHeight = 0;
    }
    return _footerInfo;
}


- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width {
    self.width = width;
    self.layoutOrigin = origin;
    CGFloat headerHeight = self.headerInfo.expectedHeight;
    if ([self.headerInfo respondsToSelector:@selector(computeHeightWithWidth:)]) {
        headerHeight =[self.headerInfo computeHeightWithWidth:width];
    }
    self.headerInfo.frame = CGRectMake(self.layoutOrigin.x, self.layoutOrigin.y, width, headerHeight);
}

@end
