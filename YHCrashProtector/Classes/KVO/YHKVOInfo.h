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

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
