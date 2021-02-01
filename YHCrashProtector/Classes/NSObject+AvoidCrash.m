//
//  NSObject+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSObject+AvoidCrash.h"
#import "AvoidUtils.h"
#import "AvoidCrashGuardProxy.h"
#import "YHBadAccessManager.h"

@implementation NSObject (AvoidCrash)

static NSMutableArray *_noneSelClassStrings;
static NSMutableArray *_noneSelClassStringPrefixs;
+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // setValue:forKey:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forKey:) newMethod:@selector(avoidCrashSetValue:forKey:)];
        
        // setValue:forKeyPath:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forKeyPath:) newMethod:@selector(avoidCrashSetValue:forKeyPath:)];
        
        // setValue:forUndefinedKey:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValue:forUndefinedKey:) newMethod:@selector(avoidCrashSetValue:forUndefinedKey:)];
        
        // setValuesForKeysWithDictionary:
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(setValuesForKeysWithDictionary:) newMethod:@selector(avoidCrashSetValuesForKeysWithDictionary:)];
        
        /** unrecognized selector sent to instance
         1、resolveInstanceMethod/resolveClassMethod需要在类的本身上动态添加它本身不存在的方法，这些方法对于该类本身来说冗余的
         2、forwardingTargetForSelector可以将消息转发给一个对象，开销较小，并且被重写的概率较低，适合重写
         */
        _noneSelClassStrings = @[@"NSNull", @"NSNumber", @"NSString", @"NSDictionary", @"NSArray"].mutableCopy;
        _noneSelClassStringPrefixs = @[].mutableCopy;
        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(forwardingTargetForSelector:) newMethod:@selector(avoidCrashForwardingTargetForSelector:)];
        
        /** 原作者处理策略
         
         forwardInvocation不适合处理unrecognized selector sent to instance Crash的说明：
         
         （1）forwardInvocation可以通过NSInvocation的形式将消息转发给多个对象，但是其开销较大，需要创建新的NSInvocation对象
         （2）forwardInvocation的函数经常被使用者调用，来做多层消息转发选择机制
         
         结论：此方法【不适合】多次重写
        
         [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(methodSignatureForSelector:) newMethod:@selector(avoidCrashMethodSignatureForSelector:)];
         [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(forwardInvocation:) newMethod:@selector(avoidCrashForwardInvocation:)];
        
        */
        
        // dealloc
//        [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:NSSelectorFromString(@"dealloc") newMethod:@selector(avoidCrashDealloc)];
    });
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

#pragma mark - unrecognized selector sent to instance
// 初始化一个需要防止 ”unrecognized selector sent to instance” 的崩溃的类名数组
// ⚠️不可将@"NSObject"加入classStrings数组中
// ⚠️不可将UI前缀的字符串加入classStrings数组中
+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (NSString *className in classStrings) {
            if (![className hasPrefix:@"UI"] &&
                ![className isEqualToString:NSStringFromClass([NSObject class])] &&
                ![_noneSelClassStrings containsObject:className]) {
                [_noneSelClassStrings addObject:className];
            }
        }
    });
}

// 初始化一个需要防止 ”unrecognized selector sent to instance” 的崩溃的类名前缀的数组
// ⚠️不可将UI前缀的字符串(包括@"UI")加入classStringPrefixs数组中
// ⚠️不可将NS前缀的字符串(包括@"NS")加入classStringPrefixs数组中
+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (NSString *classNamePrefix in classStringPrefixs) {
            if (![classNamePrefix hasPrefix:@"UI"] &&
                ![classNamePrefix hasPrefix:@"NS"]) {
                [_noneSelClassStringPrefixs addObject:classNamePrefix];
            }
        }
    });
}

- (id)avoidCrashForwardingTargetForSelector:(SEL)aSelector {
    BOOL flag = NO;
    for (NSString *classStr in _noneSelClassStrings) {
        if ([self isKindOfClass:NSClassFromString(classStr)]) {
            flag = YES;
            break;
        }
    }

    if (!flag) {
        NSString *selfClass = NSStringFromClass([self class]);
        for (NSString *classStrPrefix in _noneSelClassStringPrefixs) {
            if ([selfClass hasPrefix:classStrPrefix]) {
                flag = YES;
                break;
            }
        }
    }

    return flag ? [AvoidCrashGuardProxy handleObject:self forwardingTargetForSelector:aSelector] : nil;
}

#pragma mark - dealloc
- (void)avoidCrashDealloc {
    if ([NSStringFromClass([self class]) isEqualToString:@"HCIMConversationNavShimmerLable"]) {
        [[YHBadAccessManager sharedInstance] handleDeallocObject:self];
    } else {
        [self avoidCrashDealloc];
    }
}

#pragma mark - 原作者处理策略
/**

// 消息转发阶段hook methodSignatureForSelector 方法做一些自定义逻辑处理
- (NSMethodSignature *)avoidCrashMethodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *ms = [self avoidCrashMethodSignatureForSelector:aSelector];
    BOOL flag = NO;
    if (ms == nil) {
        for (NSString *classStr in _noneSelClassStrings) {
            if ([self isKindOfClass:NSClassFromString(classStr)]) {
                // 获取代理方法的签名
                ms = [AvoidCrashGuardProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
                flag = YES;
                break;
            }
        }
    }

    if (!flag) {
        NSString *selfClass = NSStringFromClass([self class]);
        for (NSString *classStrPrefix in _noneSelClassStringPrefixs) {
            if ([selfClass hasPrefix:classStrPrefix]) {
                ms = [AvoidCrashGuardProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
            }
        }
    }

    return ms;
}

// 消息转发阶段如果方法签名不为空，hook forwardInvocation 方法做一些自定义逻辑处理
- (void)avoidCrashForwardInvocation:(NSInvocation *)anInvocation {
    @try {
        [self avoidCrashForwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {

    }
}

*/

@end
