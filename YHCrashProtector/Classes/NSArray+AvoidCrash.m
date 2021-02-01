//
//  NSArray+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSArray+AvoidCrash.h"
#import "AvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];这种创建方式其实调用的是下面的方法：
 *
 *  + (instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
 *
 *  - (id)objectAtIndex:(NSUInteger)index
 *  - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 *
 */

@implementation NSArray (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // ----------- 以下为类对象方法交换（class method） -----------
        
        // arrayWithObjects:count:
        [AvoidUtils exchangeClassMethod:[self class] oldMethod:@selector(arrayWithObjects:count:) newMethod:@selector(AvoidCrashArrayWithObjects:count:)];
        
        // ----------- 以下为对象方法交换（instance method） -----------
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        // objectsAtIndexes:
        [AvoidUtils exchangeInstanceMethod:__NSArray oldMethod:@selector(objectsAtIndexes:) newMethod:@selector(avoidCrashObjectsAtIndexes:)];
        
        // objectAtIndex:
        [AvoidUtils exchangeInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSArrayIAvoidCrashObjectAtIndex:)];
        [AvoidUtils exchangeInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSSingleObjectArrayIAvoidCrashObjectAtIndex:)];
        [AvoidUtils exchangeInstanceMethod:__NSArray0 oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSArray0AvoidCrashObjectAtIndex:)];
        
        // objectAtIndexedSubscript:
        if (AvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [AvoidUtils exchangeInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(__NSArrayIAvoidCrashObjectAtIndexedSubscript:)];
        }
        
        // getObjects:range:
        [AvoidUtils exchangeInstanceMethod:__NSArray oldMethod:@selector(getObjects:range:) newMethod:@selector(NSArrayAvoidCrashGetObjects:range:)];
        [AvoidUtils exchangeInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(getObjects:range:) newMethod:@selector(__NSSingleObjectArrayIAvoidCrashGetObjects:range:)];
        [AvoidUtils exchangeInstanceMethod:__NSArrayI oldMethod:@selector(getObjects:range:) newMethod:@selector(__NSArrayIAvoidCrashGetObjects:range:)];
    });
}

#pragma mark - 以下为类对象方法交换（class method）
#pragma mark - arrayWithObjects:count:
+ (instancetype)AvoidCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    id instance = nil;
    @try {
        instance = [self AvoidCrashArrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to remove nil object and instance a array.";
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        
        // 以下是对错误数据的处理，把为nil的数据去掉，然后初始化数组
        NSInteger newObjsIndex = 0;
        id _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        
        instance = [self AvoidCrashArrayWithObjects:newObjects count:newObjsIndex];
    } @finally {
        return instance;
    }
}

#pragma mark - 以下为对象方法交换（instance method）
#pragma mark - objectAtIndexedSubscript:
- (id)__NSArrayIAvoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - objectsAtIndexes:
- (NSArray *)avoidCrashObjectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self avoidCrashObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return returnArray;
    }
}

#pragma mark - objectAtIndex:
// __NSArrayI objectAtIndex:
- (id)__NSArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

// __NSSingleObjectArrayI objectAtIndex:
- (id)__NSSingleObjectArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSSingleObjectArrayIAvoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

// __NSArray0 objectAtIndex:
- (id)__NSArray0AvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSArray0AvoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - getObjects:range:
// NSArray getObjects:range:
- (void)NSArrayAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    @try {
        [self NSArrayAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

// __NSSingleObjectArrayI  getObjects:range:
- (void)__NSSingleObjectArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    @try {
        [self __NSSingleObjectArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

// __NSArrayI  getObjects:range:
- (void)__NSArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    @try {
        [self __NSArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
