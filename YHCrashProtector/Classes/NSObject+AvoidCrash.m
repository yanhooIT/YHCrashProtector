//
//  NSObject+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSObject+AvoidCrash.h"
#import "AvoidUtils.h"

@implementation NSObject (AvoidCrash)

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

@end
