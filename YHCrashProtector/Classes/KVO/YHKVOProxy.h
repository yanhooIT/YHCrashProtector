//
//  YHKVOProxy.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHKVOProxy : NSObject

/// 被观察对象
@property (nonatomic, weak) NSObject *observedObject;

- (BOOL)yh_canAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

- (BOOL)yh_canRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
