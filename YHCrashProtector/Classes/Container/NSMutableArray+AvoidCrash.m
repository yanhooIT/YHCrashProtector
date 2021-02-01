//
//  NSMutableArray+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableArray+AvoidCrash.h"
#import "AvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1. - (id)objectAtIndex:(NSUInteger)index
 *  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  3. - (void)removeObjectAtIndex:(NSUInteger)index
 *  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  5. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 *
 */

@implementation NSMutableArray (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        
        // objectAtIndex:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(objectAtIndex:) newMethod:@selector(avoidCrashObjectAtIndex:)];
        
        // objectAtIndexedSubscript
        if (AvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(avoidCrashObjectAtIndexedSubscript:)];
        }
        
        // setObject:atIndexedSubscript:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(setObject:atIndexedSubscript:) newMethod:@selector(avoidCrashSetObject:atIndexedSubscript:)];
        
        // removeObjectAtIndex:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(removeObjectAtIndex:) newMethod:@selector(avoidCrashRemoveObjectAtIndex:)];
        
        // insertObject:atIndex:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(insertObject:atIndex:) newMethod:@selector(avoidCrashInsertObject:atIndex:)];
        
        // getObjects:range:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(getObjects:range:) newMethod:@selector(avoidCrashGetObjects:range:)];
        
        // replaceObjectAtIndex:withObject:
        [AvoidUtils exchangeInstanceMethod:arrayMClass oldMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(avoidCrashReplaceObjectAtIndex:withObject:)];
    });
}

#pragma mark - get object from array
- (void)avoidCrashSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self avoidCrashSetObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - removeObjectAtIndex:
- (void)avoidCrashRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self avoidCrashRemoveObjectAtIndex:index];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - set方法
- (void)avoidCrashInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self avoidCrashInsertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [AvoidUtils noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    } @finally {
        
    }
}

#pragma mark - objectAtIndex:
- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self avoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - getObjects:range:
- (void)avoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self avoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - replaceObjectAtIndex:withObject:
- (void)avoidCrashReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    @try {
        [self avoidCrashReplaceObjectAtIndex:index withObject:anObject];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
