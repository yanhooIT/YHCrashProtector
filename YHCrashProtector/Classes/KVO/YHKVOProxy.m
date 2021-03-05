//
//  YHKVOProxy.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import "YHKVOProxy.h"
#import "YHKVOInfo.h"
#import "AVoidUtils.h"

@implementation YHKVOProxy {
    dispatch_semaphore_t _lock;
    NSMapTable<NSString *, NSMutableSet<YHKVOInfo *> *> *_objectInfosMap;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);// 并发线程数为1
        _objectInfosMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
    }
    
    return self;
}

- (void)dealloc {
    [self _removeAllObservers];
    _lock = nil;
}

- (BOOL)yh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    YHLock();
    
    // 是否已存在此观察对象
    BOOL isContainObserver = NO;
    
    // 查看被观察对象的keyPath是否有观察对象集合
    NSMutableSet *kvoInfos = [_objectInfosMap objectForKey:keyPath];
    if (nil == kvoInfos) {// 没有观察对象
        kvoInfos = [NSMutableSet set];
        [_objectInfosMap setObject:kvoInfos forKey:keyPath];
    } else {// 存在观察对象
        for (YHKVOInfo *info in kvoInfos) {
            if ([info.observer isEqual:observer]
                && [info.keyPath isEqualToString:keyPath])
            {
                isContainObserver = YES;
                break;
            }
        }
    }
    
    if (!isContainObserver) {
        YHKVOInfo *kvoInfo = [[YHKVOInfo alloc] initWithObserver:observer keyPath:keyPath options:options context:context];
        [kvoInfos addObject:kvoInfo];
    }
    
    YHUnlock();
    
    return isContainObserver;
}

- (BOOL)yh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    YHLock();
    
    // 是否存在观察对象
    YHKVOInfo *registeredInfo = nil;
    
    // 查看被观察对象的keyPath是否有观察对象集合
    NSMutableSet *kvoInfos = [_objectInfosMap objectForKey:keyPath];
    if (nil != kvoInfos) {
        for (YHKVOInfo *info in kvoInfos) {
            if ([info.observer isEqual:observer]
                && [info.keyPath isEqualToString:keyPath])
            {
                registeredInfo = info;
                break;
            }
        }
    }
    
    BOOL isContainObserver = NO;
    if (registeredInfo != nil) {
        isContainObserver = YES;
        [kvoInfos removeObject:registeredInfo];
        
        if (0 == kvoInfos.count) {
            [_objectInfosMap removeObjectForKey:keyPath];
        }
    }
    
    YHUnlock();
    
    return isContainObserver;
}

/// 移除【被观察对象】上的所有【观察对象】
- (void)_removeAllObservers {
    YHLock();
    
    NSMapTable *objectInfosMap = [_objectInfosMap copy];
    [_objectInfosMap removeAllObjects];
    
    NSArray *allKeyPaths = [[objectInfosMap keyEnumerator] allObjects];
    for (NSString *keyPath in allKeyPaths) {
        NSMutableSet *kvoInfos = [objectInfosMap objectForKey:keyPath];
        for (YHKVOInfo *info in kvoInfos) {
            [self.observedObject removeObserver:info.observer forKeyPath:info.keyPath];
        }
    }
    
    YHUnlock();
}

@end