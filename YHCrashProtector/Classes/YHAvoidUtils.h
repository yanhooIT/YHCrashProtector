//
//  YHAvoidUtils.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>
#import "YHAvoidLogger.h"

// 互斥锁
#define AvoidCrashLock()    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define AvoidCrashUnlock()  dispatch_semaphore_signal(self->_lock)

NS_ASSUME_NONNULL_BEGIN

@interface YHAvoidUtils : NSObject

/**
 *  类方法的交换
 *
 *  @param anClass   元类对象
 *  @param oldMethod 源方法
 *  @param newMethod 自定义的方法
 */
+ (void)yh_swizzleClassMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/**
 *  对象方法的交换
 *
 *  @param anClass   类对象
 *  @param oldMethod 源方法
 *  @param newMethod 自定义的方法
 */
+ (void)yh_swizzleInstanceMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/// 根据前缀判断是否是系统类（并不全面，只是做一个简单的过滤）
+ (BOOL)yh_isSystemClassWithPrefix:(NSString *)classPrefix;

/// 根据Class判断是否是系统类
+ (BOOL)yh_isSystemClass:(Class)cls;

/// 判断selector有几个参数
+ (NSUInteger)yh_selectorArgumentCount:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
