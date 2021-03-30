//
//  NSObject+KVOCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import "NSObject+KVOCrash.h"
#import <objc/runtime.h>
#import "YHAvoidUtils.h"
#import "YHKVOInfo.h"

@implementation NSObject (KVOCrash)

+ (void)yh_enabledAvoidKVOCrash {
    // 注册观察对象
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(addObserver:forKeyPath:options:context:) newMethod:@selector(yh_addObserver:forKeyPath:options:context:)];
    
    // 移除观察对象
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(removeObserver:forKeyPath:) newMethod:@selector(yh_removeObserver:forKeyPath:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(removeObserver:forKeyPath:context:) newMethod:@selector(yh_removeObserver:forKeyPath:context:)];
    
    // 被观察对象属性发生改变通知观察对象
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(observeValueForKeyPath:ofObject:change:context:) newMethod:@selector(yh_observeValueForKeyPath:ofObject:change:context:)];
}

- (void)yh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([self.kvoProxy yh_canAddObserver:observer forKeyPath:keyPath options:options context:context]) {
        [self yh_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
        [self yh_removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
        [self yh_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

- (void)yh_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([self.kvoProxy yh_canHandleObserverCallbackWithKeyPath:keyPath]) {
        [self yh_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
        
        [self setKvoProxy:proxy];
    }
    
    return proxy;
}

@end
