//
//  NSObject+KVOCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import "NSObject+KVOCrash.h"
#import <objc/runtime.h>
#import "AvoidUtils.h"
#import "YHKVOInfo.h"

@implementation NSObject (KVOCrash)

+ (void)enabledAvoidKVOCrash {
    // 注册观察对象
    [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(addObserver:forKeyPath:options:context:) newMethod:@selector(yh_addObserver:forKeyPath:options:context:)];
    
    // 移除观察对象
    [AvoidUtils exchangeInstanceMethod:[self class] oldMethod:@selector(removeObserver:forKeyPath:) newMethod:@selector(yh_removeObserver:forKeyPath:)];
}

- (void)yh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (yh_isSystemClass(observer.class)) {
        [self yh_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        if (![self.kvoProxy yh_addObserver:observer forKeyPath:keyPath options:options context:context]) {
            [self yh_addObserver:observer forKeyPath:keyPath options:options context:context];
        }
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if (yh_isSystemClass(observer.class)) {
        [self yh_removeObserver:observer forKeyPath:keyPath];
    } else {
        if ([self.kvoProxy yh_removeObserver:observer forKeyPath:keyPath]) {
            [self yh_removeObserver:observer forKeyPath:keyPath];
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
        proxy.observedObject = self;
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

@end
