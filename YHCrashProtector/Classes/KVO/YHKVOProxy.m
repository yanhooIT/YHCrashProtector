//
//  YHKVOProxy.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import "YHKVOProxy.h"
#import "YHKVOInfo.h"
#import "YHAvoidUtils.h"

@implementation YHKVOProxy {
    dispatch_semaphore_t _lock;
    NSMapTable<NSString *, NSMutableSet<YHKVOInfo *> *> *_objectInfosMap;
    NSString *_observedObjClassName;
}

// 自定义类的前缀
static NSMutableArray *_cusClassPrefixs;
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cusClassPrefixs = [NSMutableArray array];
    });
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

+ (void)setupHandleKVOCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    for (NSString *classPrefix in classPrefixs) {
        if (yh_isSystemClassWithPrefix(classPrefix)) continue;
        
        [_cusClassPrefixs addObject:classPrefix];
    }
}

- (BOOL)yh_canAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    AvoidCrashLock();
    
    // 是否已存在此观察对象
    BOOL canAddObserver = YES;
    if (![self _isSystemClass]) {
        // 查看被观察对象的keyPath是否有观察对象集合
        NSMutableSet *kvoInfos = [_objectInfosMap objectForKey:keyPath];
        if (nil == kvoInfos) {// 没有观察对象
            kvoInfos = [NSMutableSet set];
            [_objectInfosMap setObject:kvoInfos forKey:keyPath];
        } else {// 存在观察对象
            for (YHKVOInfo *info in kvoInfos) {
                if (info.observerHash == [observer hash] && [info.keyPath isEqualToString:keyPath])
                {
                    canAddObserver = NO;
                    break;
                }
            }
        }
        
        if (canAddObserver && observer && !AvoidCrash_STRING_IS_EMPTY(keyPath)) {
            YHKVOInfo *kvoInfo = [[YHKVOInfo alloc] initWithObserver:observer keyPath:keyPath];
            [kvoInfos addObject:kvoInfo];
        }
    }
    
    AvoidCrashUnlock();
    
    return canAddObserver;
}

- (BOOL)yh_canRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    AvoidCrashLock();
    
    BOOL canRemoveObserver = YES;
    if (![self _isSystemClass]) {
        YHKVOInfo *registeredInfo = nil;
        // 查看被观察对象的keyPath是否有观察对象集合
        NSMutableSet *kvoInfos = [_objectInfosMap objectForKey:keyPath];
        if (nil != kvoInfos) {
            for (YHKVOInfo *info in kvoInfos) {
                if (info.observerHash == [observer hash] && [info.keyPath isEqualToString:keyPath])
                {
                    registeredInfo = info;
                    break;
                }
            }
        }
        
        canRemoveObserver = NO;
        if (registeredInfo != nil) {// 存在观察对象
            canRemoveObserver = YES;
            
            [kvoInfos removeObject:registeredInfo];
            
            if (0 == kvoInfos.count) {
                [_objectInfosMap removeObjectForKey:keyPath];
            }
        }
    }
    
    AvoidCrashUnlock();
    
    return canRemoveObserver;
}

- (BOOL)yh_canHandleObserverCallbackWithKeyPath:(NSString *)keyPath
{
    AvoidCrashLock();
    
    BOOL needHandleObserver = YES;
    if (![self _isSystemClass]) {
        // 查看被观察对象的keyPath是否有观察对象集合
        NSMutableSet *kvoInfos = [_objectInfosMap objectForKey:keyPath];
        if (nil != kvoInfos) {
            NSMutableSet *tmp = [kvoInfos copy];
            for (YHKVOInfo *info in tmp) {
                if (nil == info.observer) {// 观察对象已经释放
                    [kvoInfos removeObject:info];
                }
            }
        }
        
        if (nil == kvoInfos || 0 == kvoInfos.count) {
            needHandleObserver = NO;
            [_objectInfosMap removeObjectForKey:keyPath];
        }
    }
    
    AvoidCrashUnlock();
    
    return needHandleObserver;
}

/// 移除【被观察对象】上的所有【观察对象】
- (void)_removeAllObservers {
    AvoidCrashLock();
    
    NSMapTable *objectInfosMap = [_objectInfosMap copy];
    [_objectInfosMap removeAllObjects];
    
    NSArray *allKeyPaths = [[objectInfosMap keyEnumerator] allObjects];
    for (NSString *keyPath in allKeyPaths) {
        NSMutableSet *kvoInfos = [objectInfosMap objectForKey:keyPath];
        for (YHKVOInfo *info in kvoInfos) {
            [self.observedObject removeObserver:info.observer forKeyPath:info.keyPath];
        }
    }
    
    AvoidCrashUnlock();
}

- (BOOL)_isSystemClass {
    // 没有设置就说明无需做KVO Crash防护
    if (AvoidCrash_STRING_IS_EMPTY(_observedObjClassName)) return YES;
    
    for (NSString *clsPrefix in _cusClassPrefixs) {
        if ([_observedObjClassName hasPrefix:clsPrefix]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)setObservedObject:(NSObject *)observedObject {
    _observedObject = observedObject;
    
    if (_observedObject) {
        _observedObjClassName = NSStringFromClass(observedObject.class);
    }
}

@end
