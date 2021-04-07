//
//  YHKVOProxy.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHKVOProxy : NSObject

/// 是否可以添加观察对象
/// @param observer 观察对象
/// @param keyPath 被观察对象的属性 or 成员变量
/// @param options 观察策略
/// @param context 传递的上下文
- (BOOL)yh_canAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

/// 是否可以移除观察对象
/// @param observer 观察对象
/// @param keyPath 被观察对象的属性 or 成员变量
- (BOOL)yh_canRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/// 获取监听的被观察对象所有的keyPath
- (NSArray *)yh_allKeyPaths;

@end

NS_ASSUME_NONNULL_END
