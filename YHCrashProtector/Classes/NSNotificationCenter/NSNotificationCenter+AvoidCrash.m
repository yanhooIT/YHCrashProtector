//
//  NSNotificationCenter+AvoidCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSNotificationCenter+AvoidCrash.h"
#import <objc/runtime.h>
#import "AvoidUtils.h"

@implementation NSNotificationCenter (AvoidCrash)

+ (void)enabledAvoidNotificationCrash {
    [AvoidUtils exchangeInstanceMethod:self oldMethod:@selector(addObserver:selector:name:object:) newMethod:@selector(yh_addObserver:selector:name:object:)];
}

- (void)yh_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject
{
    objc_setAssociatedObject(self, AvoidNotificationCrashFlagKey, @(1), OBJC_ASSOCIATION_ASSIGN);
    [self yh_addObserver:observer selector:aSelector name:aName object:anObject];
}

@end
