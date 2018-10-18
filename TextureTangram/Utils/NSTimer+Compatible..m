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
#import "NSTimer+Compatible.h"
#import "TANWeakProxy.h"

@implementation NSTimer (SmartUtils)

+ (void)tan_timerExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(tan_timerExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(tan_timerExecBlock:) userInfo:[block copy] repeats:repeats];
}
#endif

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo useProxy:(BOOL)shouldUseProxy runloopMode:(NSRunLoopMode)runloopMode {
    id target = shouldUseProxy?[[TANWeakProxy alloc] initWithTarget:aTarget]:aTarget;
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:target selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:runloopMode];
    return timer;
}

-(void)tan_pause
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)tan_resume
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)tan_resumeAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
