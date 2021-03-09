//
//  NSMutableArray+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableArray+AvoidCrash.h"
#import "YHAvoidUtils.h"

/** Array类簇
 // ------ NSArray ------
 // __NSPlaceholderArray
 NSLog(@"[NSArray alloc].class: %@", [NSArray alloc].class);
 // __NSArray0
 NSLog(@"[[NSArray alloc] init].class: %@", [[NSArray alloc] init].class);
 // __NSArray0
 NSLog(@"@[].class: %@", @[].class);
 // __NSSingleObjectArrayI
 NSLog(@"@[@1].class: %@", @[@1].class);
 // __NSArrayI
 NSLog(@"@[@1, @2].class: %@", @[@1, @2].class);

 // ------ NSMutableArray ------
 // __NSPlaceholderArray
 NSLog(@"[NSMutableArray alloc].class: %@", [NSMutableArray alloc].class);
 // __NSArrayM
 NSLog(@"[[NSMutableArray alloc] init].class: %@", [[NSMutableArray alloc] init].class);
 // __NSArrayM
 NSLog(@"[@[].mutableCopy class]: %@", [@[].mutableCopy class]);
 // __NSArrayM
 NSLog(@"[@[@1].mutableCopy class]: %@", [@[@1].mutableCopy class]);
 // __NSArrayM
 NSLog(@"[@[@1, @2].mutableCopy class]: %@", [@[@1, @2].mutableCopy class]);
 */

@implementation NSMutableArray (AvoidCrash)

+ (void)yh_enabledAvoidArrayMCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSMutableArray 生成的都是 __NSArrayM 类型
        Class __NSArrayM = NSClassFromString(@"__NSArrayM");
        
        // objectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_NSArrayMobjectAtIndex:)];
        
        // objectAtIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_NSArrayMobjectAtIndexedSubscript:)];
        
        // addObject:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(addObject:) newMethod:@selector(yh_addObject:)];
        
        // insertObject:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(insertObject:atIndex:) newMethod:@selector(yh_insertObject:atIndex:)];
        
        // setObject:atIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(setObject:atIndexedSubscript:) newMethod:@selector(yh_setObject:atIndexedSubscript:)];
        
        // removeObjectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(removeObjectAtIndex:) newMethod:@selector(yh_removeObjectAtIndex:)];
        
        // replaceObjectAtIndex:withObject:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(yh_replaceObjectAtIndex:withObject:)];
    });
}

- (id)yh_NSArrayMobjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"[%@ - objectAtIndex:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    return [self yh_NSArrayMobjectAtIndex:index];
}

- (id)yh_NSArrayMobjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count ) {
        NSString *log = [NSString stringWithFormat:@"[%@ - objectAtIndexedSubscript:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    return [self yh_NSArrayMobjectAtIndexedSubscript:index];
}

- (void)yh_addObject:(id)anObject {
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"[%@ - addObject:]: An attempt was made to set an object nil to the array", NSStringFromClass(self.class)];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_addObject:anObject];
}

- (void)yh_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"[%@ - insertObject:atIndex:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), index];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    if (index > self.count ) {
        NSString *log = [NSString stringWithFormat:@"[%@ - insertObject:atIndex:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_insertObject:anObject atIndex:index];
}

- (void)yh_setObject:(id)obj atIndexedSubscript:(NSUInteger)index {
    if (nil == obj) {
        NSString *log = [NSString stringWithFormat:@"[%@ - setObject:atIndexedSubscript:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), index];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    if (index > self.count ) {
        NSString *log = [NSString stringWithFormat:@"[%@ - setObject:atIndexedSubscript:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_setObject:obj atIndexedSubscript:index];
}

- (void)yh_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"[%@ - removeObjectAtIndex:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_removeObjectAtIndex:index];
}

- (void)yh_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"[%@ - replaceObjectAtIndex:withObject:]: index %ld beyond bounds, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"[%@ - replaceObjectAtIndex:withObject:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), index];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_replaceObjectAtIndex:index withObject:anObject];
}

@end
