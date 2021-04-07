//
//  NSArray+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSArray+AvoidCrash.h"
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

@implementation NSArray (AvoidCrash)

+ (void)yh_enabledAvoidArrayCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSArray/NSMutableArray 在 alloc 阶段生成的是 __NSPlaceholderArray 的中间对象
        Class __NSPlaceholderArray = NSClassFromString(@"__NSPlaceholderArray");
        
        // NSArray 包含 0 个对象时生成的是 __NSArray0 类型
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        // NSArray 包含 1 个对象生成的是 __NSSingleObjectArrayI 类型
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        // NSArray 包含多个对象时生成的是 __NSArrayI 类型
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        
        // initWithObjects:count:
        // arrayWithObjects:count:不需要hook，最终都会走initWithObjects:count:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSPlaceholderArray oldMethod:@selector(initWithObjects:count:) newMethod:@selector(yh_initWithObjects:count:)];
        
        // objectAtIndex:（无需hook，因为最终都会转调objectAtIndexedSubscript:方法）
//        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArray0 oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_NSArray0objectAtIndex:)];
//        [YHAvoidUtils yh_swizzleInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_NSSingleObjectArrayIobjectAtIndex:)];
//        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_NSArrayIobjectAtIndex:)];
        
        // objectAtIndexedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArray0 oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_NSArray0objectAtIndexedSubscript:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_NSSingleObjectArrayIobjectAtIndexedSubscript:)];
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_NSArrayIobjectAtIndexedSubscript:)];
    });
}

- (instancetype)yh_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger index = 0; index < cnt ; index++) {
        id obj = objects[index];
        if (nil == obj) {
            NSString *log = [NSString stringWithFormat:@"[%@ - initWithObjects:count:]: attempt to insert nil object from objects[%ld]", NSStringFromClass(self.class), index];
            [YHAvoidUtils yh_reportError:log];
            continue;
        }
        
        safeObjects[j] = obj;
        j++;
    }
    
    return [self yh_initWithObjects:safeObjects count:j];
}

- (id)yh_NSArray0objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [self _formatLogWithSEL:@"__NSArray0objectAtIndex:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArray0objectAtIndex:index];
}

- (id)yh_NSSingleObjectArrayIobjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [self _formatLogWithSEL:@"__NSSingleObjectArrayIobjectAtIndex:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSSingleObjectArrayIobjectAtIndex:index];
}

- (id)yh_NSArrayIobjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *log = [self _formatLogWithSEL:@"__NSArrayIobjectAtIndex:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArrayIobjectAtIndex:index];
}

- (id)yh_NSArray0objectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count ) {
        NSString *log = [self _formatLogWithSEL:@"__NSArray0objectAtIndexedSubscript:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArray0objectAtIndexedSubscript:index];
}

- (id)yh_NSSingleObjectArrayIobjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count ) {
        NSString *log = [self _formatLogWithSEL:@"__NSSingleObjectArrayIobjectAtIndexedSubscript:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSSingleObjectArrayIobjectAtIndexedSubscript:index];
}

- (id)yh_NSArrayIobjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count ) {
        NSString *log = [self _formatLogWithSEL:@"__NSArrayIobjectAtIndexedSubscript:" index:index];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_NSArrayIobjectAtIndexedSubscript:index];
}

#pragma mark - Log
- (NSString *)_formatLogWithSEL:(NSString *)sel index:(NSUInteger)index {
    return [NSString stringWithFormat:@"[%@ - %@]: index %ld beyond bounds, array count = %ld", NSStringFromClass(self.class), sel, index, self.count];
}

@end
