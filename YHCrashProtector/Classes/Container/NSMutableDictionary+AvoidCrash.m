//
//  NSMutableDictionary+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableDictionary+AvoidCrash.h"
#import "AvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */

@implementation NSMutableDictionary (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        // setObject:forKey:
        [AvoidUtils exchangeInstanceMethod:dictionaryM oldMethod:@selector(setObject:forKey:) newMethod:@selector(avoidCrashSetObject:forKey:)];
        
        // setObject:forKeyedSubscript:
        if (AvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [AvoidUtils exchangeInstanceMethod:dictionaryM oldMethod:@selector(setObject:forKeyedSubscript:) newMethod:@selector(avoidCrashSetObject:forKeyedSubscript:)];
        }
        
        // removeObjectForKey:
        Method removeObjectForKey = class_getInstanceMethod(dictionaryM, @selector(removeObjectForKey:));
        Method avoidCrashRemoveObjectForKey = class_getInstanceMethod(dictionaryM, @selector(avoidCrashRemoveObjectForKey:));
        method_exchangeImplementations(removeObjectForKey, avoidCrashRemoveObjectForKey);
    });
}

#pragma mark - setObject:forKey:
- (void)avoidCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self avoidCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - setObject:forKeyedSubscript:
- (void)avoidCrashSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self avoidCrashSetObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - removeObjectForKey:
- (void)avoidCrashRemoveObjectForKey:(id)aKey {
    @try {
        [self avoidCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

@end
