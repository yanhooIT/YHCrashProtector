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
        
        // arrayWithObjects:count:
        [YHAvoidUtils yh_swizzleClassMethod:__NSPlaceholderArray oldMethod:@selector(arrayWithObjects:count:) newMethod:@selector(yh_arrayWithObjects:count:)];
        // initWithObjects:count:
        [YHAvoidUtils yh_swizzleClassMethod:__NSPlaceholderArray oldMethod:@selector(initWithObjects:count:) newMethod:@selector(yh_initWithObjects:count:)];
        
        // objectAtIndex:
        [YHAvoidUtils yh_swizzleClassMethod:__NSArray0 oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_objectAtIndex:)];
        [YHAvoidUtils yh_swizzleClassMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_objectAtIndex:)];
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayI oldMethod:@selector(objectAtIndex:) newMethod:@selector(yh_objectAtIndex:)];
        
        // objectAtIndexedSubscript:
        [YHAvoidUtils yh_swizzleClassMethod:__NSArray0 oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_objectAtIndexedSubscript:)];
        [YHAvoidUtils yh_swizzleClassMethod:__NSSingleObjectArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_objectAtIndexedSubscript:)];
        [YHAvoidUtils yh_swizzleClassMethod:__NSArrayI oldMethod:@selector(objectAtIndexedSubscript:) newMethod:@selector(yh_objectAtIndexedSubscript:)];
    });
}

+ (instancetype)yh_arrayWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger index = 0; index < cnt ; index++) {
        id obj = objects[index];
        if (nil == obj) {
            NSString *log = [NSString stringWithFormat:@"Error[%@ - arrayWithObjects:count:]: The index %ld position in the array is nil", NSStringFromClass(self.class), index];
            [YHAvoidUtils yh_reportErrorWithLog:log];
            continue;
        }
        
        safeObjects[j] = obj;
        j++;
    }
    
    return [self yh_arrayWithObjects:safeObjects count:j];
}

- (instancetype)yh_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger index = 0; index < cnt ; index++) {
        id obj = objects[index];
        if (nil == obj) {
            NSString *log = [NSString stringWithFormat:@"Error[%@ - initWithObjects:count:]: The index %ld position in the array is nil", NSStringFromClass(self.class), index];
            [YHAvoidUtils yh_reportErrorWithLog:log];
            continue;
        }
        
        safeObjects[j] = obj;
        j++;
    }
    
    return [self yh_initWithObjects:safeObjects count:j];
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

@end
