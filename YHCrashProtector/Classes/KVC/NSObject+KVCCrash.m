//
//  NSObject+KVCCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import "NSObject+KVCCrash.h"
#import "YHAvoidUtils.h"

@implementation NSObject (KVCCrash)

+ (void)yh_enabledAvoidKVCCrash {
    // 拦截setValue:forKey:方法，用于处理key为nil的Crash
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(setValue:forKey:) newMethod:@selector(yh_setValue:forKey:)];
}

/** 避免因key为nil导致的Crash
 
 拦截setValue:forKey:方法，用于处理key为nil的Crash
 */
- (void)yh_setValue:(id)value forKey:(NSString *)key {
    if (nil == key) {
        NSString *crashMessages = [NSString stringWithFormat:@"[<%@ %p> setValue:forKey:]: attempt to set a value for a nil key, value:%@.", NSStringFromClass([self class]), self, value];
        NSLog(@"CrashProtector - %@", crashMessages);
        return;
    }
    
    [self yh_setValue:value forKey:key];
}

#pragma mark - Override Methods
/** 设置值时，避免当找不到对应 key/keyPath 时导致的Crash
 
 setValue:forKey: 执行失败会调用 setValue: forUndefinedKey: 方法，并引发崩溃
 
 通过重写 setValue: forUndefinedKey: 方法，来避免当找不到对应key时导致的Crash
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"[<%@ %p> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key: %@, value:%@.", NSStringFromClass([self class]), self, key, value];
    NSLog(@"CrashProtector - %@", crashMessages);
}

/** 获取值时，避免当找不到对应 key/keyPath 时导致的Crash
 
 valueForKey: 执行失败会调用 valueForUndefinedKey: 方法，并引发崩溃
 
 通过重写 valueForUndefinedKey: 方法，来避免当找不到对应key时导致的Crash
 */
- (nullable id)valueForUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"[<%@ %p> valueForUndefinedKey:]: this class is not key value coding-compliant for the key: %@.", NSStringFromClass([self class]), self, key];
    NSLog(@"CrashProtector - %@", crashMessages);
    
    return self;
}

/** 避免因value为nil导致的Crash
 
 在调用 setValue:forKey: 方法时，系统如果查找到名为 set<Key>: 方法的时候，会去检测 value 的参数类型，
 当value类型为 NSNmber 的标量类型或者是 NSValue 的结构类型，但是 value 为 nil 时，会自动调用 setNilValueForKey: 方法。
 
 NSNmber 的标量类型: @(数值类型)
 NSValue 的结构类型: @(CGPoint)

 这个方法的默认实现会引发崩溃，所以通过重写 setNilValueForKey: 来解决value为nil引发的Crash
 */
- (void)setNilValueForKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"[<%@ %p> setNilValueForKey]: could not set nil as the value for the key %@.", NSStringFromClass([self class]), self, key];
    NSLog(@"CrashProtector - %@", crashMessages);
}

@end
