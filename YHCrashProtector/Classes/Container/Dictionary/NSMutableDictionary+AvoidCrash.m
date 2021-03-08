//
//  NSMutableDictionary+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableDictionary+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSMutableDictionary (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        // setObject:forKey:
        [YHAvoidUtils yh_exchangeInstanceMethod:dictionaryM oldMethod:@selector(setObject:forKey:) newMethod:@selector(avoidCrashSetObject:forKey:)];
        
        // setObject:forKeyedSubscript:
        if (YHAvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [YHAvoidUtils yh_exchangeInstanceMethod:dictionaryM oldMethod:@selector(setObject:forKeyedSubscript:) newMethod:@selector(avoidCrashSetObject:forKeyedSubscript:)];
        }
        
        // removeObjectForKey:
        [YHAvoidUtils yh_exchangeInstanceMethod:dictionaryM oldMethod:@selector(removeObjectForKey:) newMethod:@selector(avoidCrashRemoveObjectForKey:)];
    });
}

#pragma mark - setObject:forKey:
- (void)avoidCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self avoidCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - setObject:forKeyedSubscript:
- (void)avoidCrashSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self avoidCrashSetObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - removeObjectForKey:
- (void)avoidCrashRemoveObjectForKey:(id)aKey {
    @try {
        [self avoidCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

@end
