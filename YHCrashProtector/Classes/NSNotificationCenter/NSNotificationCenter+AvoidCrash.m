//
//  NSNotificationCenter+AvoidCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSNotificationCenter+AvoidCrash.h"
#import <objc/runtime.h>
#import "YHAvoidUtils.h"

@implementation NSNotificationCenter (AvoidCrash)

+ (void)yh_enabledAvoidNotificationCrash {
    [YHAvoidUtils yh_swizzleInstanceMethod:self oldMethod:@selector(addObserver:selector:name:object:) newMethod:@selector(yh_addObserver:selector:name:object:)];
}

- (void)yh_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject
{
    @try {
        objc_setAssociatedObject(self, AvoidNotificationCrashFlagKey, @(1), OBJC_ASSOCIATION_ASSIGN);
        [self yh_addObserver:observer selector:aSelector name:aName object:anObject];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        
    }
}

@end
