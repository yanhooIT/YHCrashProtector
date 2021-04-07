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
        
        // addObject:（无需hook，因为最终都会转调insertObject:atIndex:方法）
//        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(addObject:) newMethod:@selector(yh_addObject:)];
        
        // insertObject:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(insertObject:atIndex:) newMethod:@selector(yh_insertObject:atIndex:)];
        
        // setObject:atIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(setObject:atIndexedSubscript:) newMethod:@selector(yh_setObject:atIndexedSubscript:)];
        
        // replaceObjectAtIndex:withObject:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(yh_replaceObjectAtIndex:withObject:)];
        
        // removeObjectAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayM oldMethod:@selector(removeObjectsInRange:) newMethod:@selector(yh_removeObjectsInRange:)];
    });
}

- (id)yh_NSArrayMobjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [self _formatLogWithSEL:@"objectAtIndex:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArrayMobjectAtIndex:index];
}

- (id)yh_NSArrayMobjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count ) {
        NSString *log = [self _formatLogWithSEL:@"objectAtIndexedSubscript:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArrayMobjectAtIndexedSubscript:index];
}

- (void)yh_addObject:(id)anObject {
    if (nil == anObject) {
        NSString *log = [self _formatLogWithSEL:@"addObject:"];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    [self yh_addObject:anObject];
}

- (void)yh_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (nil == anObject) {
        NSString *log = [self _formatLogWithSEL:@"insertObject:atIndex:"];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    if (index > self.count) {
        NSString *log = [self _formatLogWithSEL:@"insertObject:atIndex:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    [self yh_insertObject:anObject atIndex:index];
}

- (void)yh_setObject:(id)obj atIndexedSubscript:(NSUInteger)index {
    if (nil == obj) {
        NSString *log = [self _formatLogWithSEL:@"setObject:atIndexedSubscript:"];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    if (index > self.count) {
        NSString *log = [self _formatLogWithSEL:@"setObject:atIndexedSubscript:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    [self yh_setObject:obj atIndexedSubscript:index];
}

- (void)yh_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count) {
        NSString *log = [self _formatLogWithSEL:@"replaceObjectAtIndex:withObject:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    if (nil == anObject) {
        NSString *log = [self _formatLogWithSEL:@"replaceObjectAtIndex:withObject:"];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    [self yh_replaceObjectAtIndex:index withObject:anObject];
}

- (void)yh_removeObjectsInRange:(NSRange)range {
    NSUInteger tmp = (range.location + range.length);
    if (tmp > self.count) {
        NSString *log = [NSString stringWithFormat:@"[%@ - removeObjectsInRange:]: range {%ld, %ld} extends beyond bounds for array, array count = %ld", NSStringFromClass(self.class), range.location, range.length, self.count];
        [YHAvoidUtils yh_reportError:log];
        return;
    }
    
    [self yh_removeObjectsInRange:range];
}

#pragma mark - Log
- (NSString *)_formatLogWithSEL:(NSString *)sel index:(NSUInteger)index {
    return [NSString stringWithFormat:@"[%@ - %@]: index %ld beyond bounds, array count = %ld", NSStringFromClass(self.class), sel, index, self.count];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel {
    return [NSString stringWithFormat:@"[%@ - %@]: object cannot be nil", NSStringFromClass(self.class), sel];
}

@end
