//
//  NSTimer+AvoidCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/25.
//

#import "NSTimer+AvoidCrash.h"
#import "YHAvoidUtils.h"
#import "YHWeakProxy.h"

@implementation NSTimer (AvoidCrash)

+ (void)yh_enabledAvoidTimerCrash {
    // timerWithTimeInterval:target:selector:userInfo:repeats:
    [YHAvoidUtils yh_swizzleClassMethod:self oldMethod:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) newMethod:@selector(yh_timerWithTimeInterval:target:selector:userInfo:repeats:)];
    
    // scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:
    [YHAvoidUtils yh_swizzleClassMethod:self oldMethod:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) newMethod:@selector(yh_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
}

+ (NSTimer *)yh_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    NSTimer *timer = nil;
    
    @try {
        if (yesOrNo) {
            YHWeakProxy *proxy = [YHWeakProxy proxyWithTarget:aTarget];
            proxy.oriSEL = aSelector;
            proxy.oriSELHasParam = [NSStringFromSelector(aSelector) containsString:@":"];
            SEL proxySEL = @selector(proxyTimerActionWithTimer:);
            timer = [self yh_timerWithTimeInterval:ti target:proxy selector:proxySEL userInfo:userInfo repeats:yesOrNo];
        } else {
            timer = [self yh_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return timer;
    }
}

+ (NSTimer *)yh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    NSTimer *timer = nil;
    
    @try {
        if (yesOrNo) {
            YHWeakProxy *proxy = [YHWeakProxy proxyWithTarget:aTarget];
            proxy.oriSEL = aSelector;
            proxy.oriSELHasParam = [NSStringFromSelector(aSelector) containsString:@":"];
            SEL proxySEL = @selector(proxyTimerActionWithTimer:);
            timer = [self yh_scheduledTimerWithTimeInterval:ti target:proxy selector:proxySEL userInfo:userInfo repeats:yesOrNo];
        } else {
            timer = [self yh_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return timer;
    }
}

@end
