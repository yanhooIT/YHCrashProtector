//
//  NSMutableDictionary+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableDictionary+AvoidCrash.h"
#import "YHAvoidUtils.h"

/** Dictionary类簇
 // ------ NSDictionary ------
 // __NSPlaceholderDictionary
 NSLog(@"[NSDictionary alloc].class: %@", [NSDictionary alloc].class);
 // __NSDictionary0
 NSLog(@"[[NSDictionary alloc] init].class: %@", [[NSDictionary alloc] init].class);
 // __NSDictionary0
 NSLog(@"[@{} class]: %@", [@{} class]);
 // __NSSingleEntryDictionaryI
 NSLog(@"[@{@1:@1} class]: %@", [@{@1:@1} class]);
 // __NSDictionaryI
 NSLog(@"[@{@1:@1, @2:@2} class]: %@", [@{@1:@1, @2:@2} class]);

 // ------ NSMutableDictionary ------
 // __NSPlaceholderDictionary
 NSLog(@"[NSMutableDictionary alloc].class: %@", [NSMutableDictionary alloc].class);
 // __NSDictionaryM
 NSLog(@"[[NSMutableDictionary alloc] init].class: %@", [[NSMutableDictionary alloc] init].class);
 // __NSDictionaryM
 NSLog(@"[@{}.mutableCopy class]: %@", [@{}.mutableCopy class]);
 // __NSDictionaryM
 NSLog(@"[@{@1:@1}.mutableCopy class]: %@", [@{@1:@1}.mutableCopy class]);
 // __NSDictionaryM
 NSLog(@"[@{@1:@1, @2:@2}.mutableCopy class]: %@", [@{@1:@1, @2:@2}.mutableCopy class]);
 */

@implementation NSMutableDictionary (AvoidCrash)

+ (void)yh_enabledAvoidDictionaryMCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSDictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        // setObject:forKey:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSDictionaryM oldMethod:@selector(setObject:forKey:) newMethod:@selector(yh_setObject:forKey:)];
        
        // setObject:forKeyedSubscript:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSDictionaryM oldMethod:@selector(setObject:forKeyedSubscript:) newMethod:@selector(yh_setObject:forKeyedSubscript:)];
        
        // removeObjectForKey:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSDictionaryM oldMethod:@selector(removeObjectForKey:) newMethod:@selector(yh_removeObjectForKey:)];
    });
}

- (void)yh_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (nil == anObject || nil == aKey) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - setObject:forKey:]: key or object is nil", NSStringFromClass(self.class)];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }

    [self yh_setObject:anObject forKey:aKey];
}

- (void)yh_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (nil == obj || nil == key) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - setObject:forKeyedSubscript:]: key or object is nil", NSStringFromClass(self.class)];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_setObject:obj forKeyedSubscript:key];
}

- (void)yh_removeObjectForKey:(id)aKey {
    if (nil == aKey) {
        NSString *log = [NSString stringWithFormat:@"Error[%@ - removeObjectForKey:]: key is nil", NSStringFromClass(self.class)];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_removeObjectForKey:aKey];
}

@end
