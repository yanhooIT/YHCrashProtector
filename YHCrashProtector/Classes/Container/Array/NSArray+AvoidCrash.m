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
    id instance = nil;
    
    @try {
        id safeObjects[cnt];
        NSUInteger j = 0;
        for (NSUInteger index = 0; index < cnt ; index++) {
            id obj = objects[index];
            if (nil == obj) {
                NSString *log = [[NSString alloc] initWithFormat:@"[%@ - initWithObjects:count:]: attempt to insert nil object from objects[%ld]", NSStringFromClass(self.class), index];
                [YHAvoidLogger yh_reportError:log];
                continue;
            }
            
            safeObjects[j] = obj;
            j++;
        }
        
        instance = [self yh_initWithObjects:safeObjects count:j];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSArray0objectAtIndex:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSArray0objectAtIndex:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSArray0objectAtIndex:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSSingleObjectArrayIobjectAtIndex:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSSingleObjectArrayIobjectAtIndex:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSSingleObjectArrayIobjectAtIndex:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSArrayIobjectAtIndex:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSArrayIobjectAtIndex:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSArrayIobjectAtIndex:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSArray0objectAtIndexedSubscript:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSArray0objectAtIndexedSubscript:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSArray0objectAtIndexedSubscript:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSSingleObjectArrayIobjectAtIndexedSubscript:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSSingleObjectArrayIobjectAtIndexedSubscript:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSSingleObjectArrayIobjectAtIndexedSubscript:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (id)yh_NSArrayIobjectAtIndexedSubscript:(NSUInteger)index {
    id instance = nil;
    
    @try {
        if (index >= self.count) {
            NSString *log = [self _formatLogWithSEL:@"__NSArrayIobjectAtIndexedSubscript:" index:index];
            [YHAvoidLogger yh_reportError:log];
        } else {
            instance = [self yh_NSArrayIobjectAtIndexedSubscript:index];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - Log
- (NSString *)_formatLogWithSEL:(NSString *)sel index:(NSUInteger)index {
    return [YHAvoidLogger yh_logFormat:@"[%@ - %@]: index %ld beyond bounds, array count = %ld", NSStringFromClass(self.class), sel, index, self.count];
}

@end
