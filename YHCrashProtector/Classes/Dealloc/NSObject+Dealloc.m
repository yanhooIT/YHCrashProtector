//
//  NSObject+Dealloc.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSObject+Dealloc.h"
#import <objc/runtime.h>
#import "YHAvoidUtils.h"

#import "NSObject+BadAccessCrash.h"
#import "YHDeallocHandle.h"

#import "NSNotificationCenter+AvoidCrash.h"

#import "NSObject+KVOCrash.h"

@implementation NSObject (Dealloc)

+ (void)load {
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:NSSelectorFromString(@"dealloc") newMethod:@selector(yh_dealloc)];
}

- (void)yh_dealloc {
    // 只针对添加了flag的通知启用Crash防护
    id avoidNotificationCrashFlag = objc_getAssociatedObject(self.class, AvoidNotificationCrashFlagKey);
    if (avoidNotificationCrashFlag) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    // 只针对添加了flag的KVO启用Crash防护
    id avoidKVOCrashFlag = objc_getAssociatedObject(self.class, AvoidKVOCrashFlagKey);
    if (avoidKVOCrashFlag) {
        [self yh_removeAllObservers];
    }
    
    // 只针对添加了flag的野指针启用Crash防护
    id avoidBadAccessCrashFlag = objc_getAssociatedObject(self.class, AvoidBadAccessCrashFlagKey);
    if (avoidBadAccessCrashFlag) {
        [YHDeallocHandle handleDeallocObject:self];
    } else {
        [self yh_dealloc];
    }
}

@end
