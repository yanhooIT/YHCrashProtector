//
//  NSMutableArray+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableArray+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSMutableArray (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        
        // objectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(objectAtIndex:) newMethod:@selector(avoidCrashObjectAtIndex:)];
        
        // objectAtIndexedSubscript
        if (YHAvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(avoidCrashObjectAtIndexedSubscript:)];
        }
        
        // setObject:atIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(setObject:atIndexedSubscript:) newMethod:@selector(avoidCrashSetObject:atIndexedSubscript:)];
        
        // removeObjectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(removeObjectAtIndex:) newMethod:@selector(avoidCrashRemoveObjectAtIndex:)];
        
        // insertObject:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(insertObject:atIndex:) newMethod:@selector(avoidCrashInsertObject:atIndex:)];
        
        // getObjects:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(getObjects:range:) newMethod:@selector(avoidCrashGetObjects:range:)];
        
        // replaceObjectAtIndex:withObject:
        [YHAvoidUtils yh_swizzleInstanceMethod:arrayMClass oldMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(avoidCrashReplaceObjectAtIndex:withObject:)];
    });
}

#pragma mark - get object from array
- (void)avoidCrashSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self avoidCrashSetObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - removeObjectAtIndex:
- (void)avoidCrashRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self avoidCrashRemoveObjectAtIndex:index];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - set方法
- (void)avoidCrashInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self avoidCrashInsertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:YHAvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - objectAtIndex:
- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self avoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - objectAtIndexedSubscript:
- (id)avoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self avoidCrashObjectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - getObjects:range:
- (void)avoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self avoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - replaceObjectAtIndex:withObject:
- (void)avoidCrashReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    @try {
        [self avoidCrashReplaceObjectAtIndex:index withObject:anObject];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
