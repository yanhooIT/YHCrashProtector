//
//  NSObject+BadAccessCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSObject+BadAccessCrash.h"
#import <objc/runtime.h>
#import "AvoidUtils.h"

@implementation NSObject (BadAccessCrash)

+ (void)enabledAvoidBadAccessCrash {
    // Avoid "EXC_BAD_ACCESS" Crash
    [AvoidUtils exchangeInstanceMethod:object_getClass(self) oldMethod:@selector(allocWithZone:) newMethod:@selector(yh_allocWithZone:)];
}

#pragma mark - Avoid "EXC_BAD_ACCESS" Crash
+ (id)yh_allocWithZone:(nullable NSZone *)zone {
    if ([YHBadAccessManager isEnableZoombieObjectProtectWithClass:self]) {
        objc_setAssociatedObject(self, AvoidBadAccessCrashFlagKey, @(1), OBJC_ASSOCIATION_ASSIGN);
    }
    
    return [self yh_allocWithZone:zone];
}

@end
