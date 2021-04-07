//
//  NSObject+KVOCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import "NSObject+KVOCrash.h"
#import <objc/runtime.h>
#import "YHAvoidUtils.h"

@interface NSObject ()

@property (nonatomic, strong) YHKVOProxy *kvoProxy;

@end

@implementation NSObject (KVOCrash)

+ (void)yh_enabledAvoidKVOCrash {
    // 注册观察对象
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(addObserver:forKeyPath:options:context:) newMethod:@selector(yh_addObserver:forKeyPath:options:context:)];
    
    // 移除观察对象
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(removeObserver:forKeyPath:) newMethod:@selector(yh_removeObserver:forKeyPath:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(removeObserver:forKeyPath:context:) newMethod:@selector(yh_removeObserver:forKeyPath:context:)];
}

- (void)yh_removeAllObservers {
    NSArray *keyPaths = [self.kvoProxy yh_allKeyPaths];
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:self.kvoProxy forKeyPath:keyPath];
    }
}

- (void)yh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([YHAvoidUtils yh_isSystemClass:self.class]) {
        [self yh_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        objc_setAssociatedObject(self, AvoidKVOCrashFlagKey, @(1), OBJC_ASSOCIATION_ASSIGN);
        
        if ([self.kvoProxy yh_canAddObserver:observer forKeyPath:keyPath options:options context:context]) {
            [self yh_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
        }
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([YHAvoidUtils yh_isSystemClass:self.class]) {
        [self yh_removeObserver:observer forKeyPath:keyPath];
    } else {
        if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
            [self yh_removeObserver:self.kvoProxy forKeyPath:keyPath];
        }
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([YHAvoidUtils yh_isSystemClass:self.class]) {
        [self yh_removeObserver:observer forKeyPath:keyPath context:context];
    } else {
        if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
            [self yh_removeObserver:self.kvoProxy forKeyPath:keyPath context:context];
        }
    }
}

#pragma mark - 关联对象
- (void)setKvoProxy:(YHKVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (YHKVOProxy *)kvoProxy {
    YHKVOProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (nil == proxy) {
        proxy = [[YHKVOProxy alloc] init];
        [self setKvoProxy:proxy];
    }
    
    return proxy;
}

@end
