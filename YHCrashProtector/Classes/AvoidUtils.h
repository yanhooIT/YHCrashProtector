//
//  AvoidUtils.h
//  HBCAppCore
//
//  Created by 颜琥 on 2021/1/28.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define AvoidCrashNotification @"AvoidCrashNotification"

// 版本检查，version为float数据类型
#define AvoidCrashiOSVersionGreaterThanOrEqualTo(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

// ignore below define
#define AvoidCrashDefaultReturnNil  @"AvoidCrash default is to return nil to avoid crash."
#define AvoidCrashDefaultIgnore     @"AvoidCrash default is to ignore this operation to avoid crash."

@interface AvoidUtils : NSObject

/**
 *  类方法的交换
 *
 *  @param anClass   哪个类
 *  @param oldMethod 原本的方法
 *  @param newMethod 替换后的方法
 */
+ (void)exchangeClassMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/**
 *  对象方法的交换
 *
 *  @param anClass   哪个类
 *  @param oldMethod 原本的方法
 *  @param newMethod 替换后的方法
 */
+ (void)exchangeInstanceMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
+ (void)noteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;

@end

NS_ASSUME_NONNULL_END