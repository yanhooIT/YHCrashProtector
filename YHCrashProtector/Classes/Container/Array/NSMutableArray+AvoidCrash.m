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
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayM oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_objectAtIndex:)];
        
        // objectAtIndexedSubscript:
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayM oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_objectAtIndexedSubscript:)];
        
        // addObject:
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayM oldMethod:@selector(addObject:) newMethod:@selector(yh_addObject:)];
        
        // insertObject:atIndex:
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayM oldMethod:@selector(insertObject:atIndex:) newMethod:@selector(yh_insertObject:atIndex:)];
        
        // setObject:atIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(setObject:atIndexedSubscript:) newMethod:@selector(yh_setObject:atIndexedSubscript:)];
        
        // removeObjectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(removeObjectAtIndex:) newMethod:@selector(yh_removeObjectAtIndex:)];
        
        // replaceObjectAtIndex:withObject:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(yh_replaceObjectAtIndex:withObject:)];
    });
}

- (id)yh_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - objectAtIndex:]: Array out of bounds, index = %ld, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    return [self yh_objectAtIndex:index];
}

- (id)yh_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count ) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - objectAtIndexedSubscript:]: Array out of bounds, index = %ld, count = %ld", NSStringFromClass(self.class), idx, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    return [self yh_objectAtIndexedSubscript:idx];
}

- (void)yh_addObject:(id)anObject {
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - addObject:]: An attempt was made to set an object nil to the array", NSStringFromClass(self.class)];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_addObject:anObject];
}

- (void)yh_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - insertObject:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), index];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_insertObject:anObject atIndex:index];
}

- (void)yh_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (nil == obj) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - setObject:atIndexedSubscript:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), idx];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_setObject:obj atIndexedSubscript:idx];
}

- (void)yh_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - removeObjectAtIndex:]: Array out of bounds, index = %ld, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_removeObjectAtIndex:index];
}

- (void)yh_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - replaceObjectAtIndex:withObject:]: Array out of bounds, index = %ld, count = %ld", NSStringFromClass(self.class), index, self.count];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    if (nil == anObject) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - replaceObjectAtIndex:withObject:]: An attempt was made to set an object nil to the array at index %ld", NSStringFromClass(self.class), index];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_replaceObjectAtIndex:index withObject:anObject];
}

@end
