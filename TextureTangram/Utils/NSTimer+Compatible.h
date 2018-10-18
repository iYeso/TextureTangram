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
#import <Foundation/Foundation.h>

@interface NSTimer (SmartUtils)


#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block ;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
#endif

/**
 @param shouldUseProxy 使用代理转发，避免循环引用
 @param runloopMode runloop模式
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
                            target:(id)aTarget
                          selector:(SEL)aSelector
                          userInfo:(id)userInfo
                           repeats:(BOOL)yesOrNo
                          useProxy:(BOOL)shouldUseProxy
                       runloopMode:(NSRunLoopMode)runloopMode;

- (void)tan_pause;
- (void)tan_resume;
- (void)tan_resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
