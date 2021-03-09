//
//  NSArray+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSArray+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSArray (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // arrayWithObjects:count:
        [YHAvoidUtils yh_swizzleClassMethod:self oldMethod:@selector(arrayWithObjects:count:) newMethod:@selector(AvoidCrashArrayWithObjects:count:)];
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        // objectsAtIndexes:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArray oldMethod:@selector(objectsAtIndexes:) newMethod:@selector(avoidCrashObjectsAtIndexes:)];
        
        // objectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSArrayIAvoidCrashObjectAtIndex:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSSingleObjectArrayIAvoidCrashObjectAtIndex:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArray0 oldMethod:@selector(objectAtIndex:) newMethod:@selector(__NSArray0AvoidCrashObjectAtIndex:)];
        
        // objectAtIndexedSubscript:
        if (YHAvoidCrashiOSVersionGreaterThanOrEqualTo(11.0)) {
            [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(__NSArrayIAvoidCrashObjectAtIndexedSubscript:)];
        }
        
        // getObjects:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArray oldMethod:@selector(getObjects:range:) newMethod:@selector(NSArrayAvoidCrashGetObjects:range:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(getObjects:range:) newMethod:@selector(__NSSingleObjectArrayIAvoidCrashGetObjects:range:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayI oldMethod:@selector(getObjects:range:) newMethod:@selector(__NSArrayIAvoidCrashGetObjects:range:)];
    });
}

#pragma mark - arrayWithObjects:count:
+ (instancetype)AvoidCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    id instance = nil;
    @try {
        instance = [self AvoidCrashArrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to remove nil object and instance a array.";
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
        
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

#pragma mark - objectAtIndexedSubscript:
- (id)__NSArrayIAvoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = YHAvoidCrashDefaultReturnNil;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
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
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

// __NSSingleObjectArrayI  getObjects:range:
- (void)__NSSingleObjectArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    @try {
        [self __NSSingleObjectArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

// __NSArrayI  getObjects:range:
- (void)__NSArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    @try {
        [self __NSArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
