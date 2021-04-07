//
//  NSObject+KVOCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import "NSObject+KVOCrash.h"
#import <objc/runtime.h>
#import "YHKVOProxy.h"
#import "YHAvoidUtils.h"

@interface NSObject ()

@property (nonatomic, strong) YHKVOProxy *kvoProxy;

@end

@implementation NSObject (KVOCrash)

// 设置需要进行KVO Crash保护的类的前缀
static NSMutableArray *_cusClassPrefixs;
+ (void)setupHandleKVOCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    if (nil == _cusClassPrefixs) {
        _cusClassPrefixs = [NSMutableArray array];
    }
    
    for (NSString *classPrefix in classPrefixs) {
        if ([YHAvoidUtils yh_isSystemClassWithPrefix:classPrefix]) continue;
        
        [_cusClassPrefixs addObject:classPrefix];
    }
}

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
    if ([self _isAvoidKVOCrash]) {
        objc_setAssociatedObject(self, AvoidKVOCrashFlagKey, @(1), OBJC_ASSOCIATION_ASSIGN);
        
        if ([self.kvoProxy yh_canAddObserver:observer forKeyPath:keyPath options:options context:context]) {
            [self yh_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
        }
    } else {
        [self yh_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self _isAvoidKVOCrash]) {
        if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
            [self yh_removeObserver:self.kvoProxy forKeyPath:keyPath];
        }
    } else {
        [self yh_removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([self _isAvoidKVOCrash]) {
        if ([self.kvoProxy yh_canRemoveObserver:observer forKeyPath:keyPath]) {
            [self yh_removeObserver:self.kvoProxy forKeyPath:keyPath context:context];
        }
    } else {
        [self yh_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

// 是否规避Crash
- (BOOL)_isAvoidKVOCrash {
    // 系统类不处理
    BOOL isSysClass = [YHAvoidUtils yh_isSystemClass:self.class];
    if (isSysClass) return NO;
    
    // 未设置就全部进行KVO Crash防护
    if (nil == _cusClassPrefixs || _cusClassPrefixs.count == 0) {
        return YES;
    }
    
    NSString *className = NSStringFromClass(self.class);
    for (NSString *clsPrefix in _cusClassPrefixs) {
        if ([className hasPrefix:clsPrefix]) {
            return YES;
        }
    }
    
    return NO;
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
