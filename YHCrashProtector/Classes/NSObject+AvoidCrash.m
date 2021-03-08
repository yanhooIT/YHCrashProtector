//
//  NSObject+AvoidCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSObject+AvoidCrash.h"
#import <objc/runtime.h>
#import "AvoidUtils.h"

#import "NSObject+BadAccessCrash.h"
#import "YHDeallocHandle.h"

#import "NSNotificationCenter+AvoidCrash.h"

@implementation NSObject (AvoidCrash)

+ (void)load {
    [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:NSSelectorFromString(@"dealloc") newMethod:@selector(yh_dealloc)];
}

- (void)yh_dealloc {
    id avoidNotificationCrashFlag = objc_getAssociatedObject(self.class, AvoidNotificationCrashFlagKey);
    if (avoidNotificationCrashFlag) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    id avoidBadAccessCrashFlag = objc_getAssociatedObject(self.class, AvoidBadAccessCrashFlagKey);
    if (avoidBadAccessCrashFlag) {
        [YHDeallocHandle handleDeallocObject:self];
    } else {
        [self yh_dealloc];
    }
}

@end
