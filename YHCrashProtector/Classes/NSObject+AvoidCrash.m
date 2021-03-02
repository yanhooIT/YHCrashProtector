//
//  NSObject+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSObject+AvoidCrash.h"
#import "AvoidUtils.h"
#import "YHForwardingTarget.h"
#import "YHBadAccessManager.h"
#import "YHDeallocHandle.h"

@implementation NSObject (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /** Avoid "unrecognized selector sent to instance" Crash
         
         1、resolveInstanceMethod/resolveClassMethod需要在类的本身上动态添加它本身不存在的方法，这些方法对于该类本身来说冗余的
         2、forwardingTargetForSelector可以将消息转发给一个对象，开销较小，并且被重写的概率较低，适合重写
         3、forwardInvocation不适合处理unrecognized selector sent to instance Crash的说明：
         
         （1）forwardInvocation可以通过NSInvocation的形式将消息转发给多个对象，但是其开销较大，需要创建新的NSInvocation对象
         （2）forwardInvocation的函数经常被使用者调用，来做多层消息转发选择机制
         
         结论：forwardInvocation【不适合】多次重写
        
         [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(methodSignatureForSelector:) newMethod:@selector(avoidCrashMethodSignatureForSelector:)];
         [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(forwardInvocation:) newMethod:@selector(avoidCrashForwardInvocation:)];
         */
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(forwardingTargetForSelector:) newMethod:@selector(yh_forwardingTargetForSelector:)];
        
        // Avoid "EXC_BAD_ACCESS" Crash
        [AvoidUtils exchangeInstanceMethod:object_getClass(self) oldMethod:@selector(allocWithZone:) newMethod:@selector(yh_allocWithZone:)];
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:NSSelectorFromString(@"dealloc") newMethod:@selector(yh_dealloc)];
        
        // setValue:forKey:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forKey:) newMethod:@selector(avoidCrashSetValue:forKey:)];
        
        // setValue:forKeyPath:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forKeyPath:) newMethod:@selector(avoidCrashSetValue:forKeyPath:)];
        
        // setValue:forUndefinedKey:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forUndefinedKey:) newMethod:@selector(avoidCrashSetValue:forUndefinedKey:)];
        
        // setValuesForKeysWithDictionary:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValuesForKeysWithDictionary:) newMethod:@selector(avoidCrashSetValuesForKeysWithDictionary:)];
    });
}

#pragma mark - Avoid "unrecognized selector sent to instance" Crash
- (id)yh_forwardingTargetForSelector:(SEL)aSelector {
    return [YHForwardingTarget handleWithObject:self forwardingTargetForSelector:aSelector];
}

#pragma mark - Avoid "EXC_BAD_ACCESS" Crash
+ (id)yh_allocWithZone:(nullable NSZone *)zone {
    if ([YHBadAccessManager isEnableZoombieObjectProtectWithClass:self]) {
        objc_setAssociatedObject(self, "YH_EXC_BAD_ACCESS_PROTECTOR_FLAG", @(1), OBJC_ASSOCIATION_ASSIGN);
    }
    
    return [self yh_allocWithZone:zone];
}

- (void)yh_dealloc {
    id flag = objc_getAssociatedObject(self.class, "YH_EXC_BAD_ACCESS_PROTECTOR_FLAG");
    if (flag) {
        [YHDeallocHandle handleDeallocObject:self];
    } else {
        [self yh_dealloc];
    }
}

#pragma mark - setValue:forKey:
- (void)avoidCrashSetValue:(id)value forKey:(NSString *)key {
    @try {
        [self avoidCrashSetValue:value forKey:key];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - setValue:forKeyPath:
- (void)avoidCrashSetValue:(id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self avoidCrashSetValue:value forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - setValue:forUndefinedKey:
- (void)avoidCrashSetValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self avoidCrashSetValue:value forUndefinedKey:key];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - setValuesForKeysWithDictionary:
- (void)avoidCrashSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    @try {
        [self avoidCrashSetValuesForKeysWithDictionary:keyedValues];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
