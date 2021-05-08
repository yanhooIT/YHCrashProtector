//
//  YHKVOProxy.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import "YHKVOProxy.h"
#import "YHAvoidUtils.h"

@implementation YHKVOProxy {
    dispatch_semaphore_t _lock;
    NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *_observerMap;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);// 并发线程数为1
        _observerMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)yh_canAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    AvoidCrashLock();
    
    if (nil == observer || AvoidCrash_STRING_IS_EMPTY(keyPath)) {
        AvoidCrashUnlock();
        return NO;
    }
    
    BOOL canAddObserver = NO;
    // 观察对象集合
    NSHashTable<NSObject *> *observers = [_observerMap objectForKey:keyPath];
    if (nil == observers) {// 没有观察对象
        canAddObserver = YES;
        
        observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
        [observers addObject:observer];
        _observerMap[keyPath] = observers;
    } else {
        // 如果被观察对象已经设置了代理对象为观察者对象，后面的真正的观察者对象仅仅需要添加到集合中即可
        if (![observers containsObject:observer]) {
            [observers addObject:observer];
        }
    }
    
    AvoidCrashUnlock();
    return canAddObserver;
}

- (BOOL)yh_canRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    AvoidCrashLock();
    
    if (nil == observer || AvoidCrash_STRING_IS_EMPTY(keyPath)) {
        AvoidCrashUnlock();
        return NO;
    }
    
    BOOL canRemoveObserver = NO;
    // 查看被观察对象的keyPath是否有观察对象集合
    NSHashTable<NSObject *> *observers = [_observerMap objectForKey:keyPath];
    if (nil != observers) {
        [observers removeObject:observer];
        
        if (0 == observers.count) {// 没有真正的观察者对象就移除代理观察者对象
            [_observerMap removeObjectForKey:keyPath];
            canRemoveObserver = YES;
        }
    }
    
    AvoidCrashUnlock();
    return canRemoveObserver;
}

- (NSArray *)yh_allKeyPaths {
    NSArray *keyPaths = _observerMap.allKeys;
    return keyPaths;
}

// 实际观察者为代理对象，并分发给实际观察者对象
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
    NSHashTable<NSObject *> *observers = [_observerMap objectForKey:keyPath];
    for (NSObject *observer in observers) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            [YHAvoidLogger yh_reportException:exception];
        }
    }
}

@end
