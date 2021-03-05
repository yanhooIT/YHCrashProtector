//
//  YHKVOInfo.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHKVOInfo : NSObject

/// 观察对象
@property (nonatomic, weak, readonly) id observer;
/// 被观察对象的成员变量 or 属性
@property (nonatomic, copy, readonly) NSString *keyPath;
/// 监控策略
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
/// 上下文传递
@property (nonatomic, assign, readonly) void *context;

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END
