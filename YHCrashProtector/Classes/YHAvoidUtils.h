//
//  YHAvoidUtils.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AvoidCrashNotification @"AvoidCrashNotification"

// 互斥锁
#define AvoidCrashLock()    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define AvoidCrashUnlock()  dispatch_semaphore_signal(self->_lock)

// 【字符串】是否为空（YES为空，NO不为空）
#define AvoidCrash_STRING_IS_EMPTY(str) (nil == str || [str isKindOfClass:[NSNull class]] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1)

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

/**
 *  上报被拦截的异常信息
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 处理该异常的默认做法
 */
+ (void)yh_reportErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;

/// 上报被拦击的错误的日志信息
/// @param log 日志信息
+ (void)yh_reportErrorWithLog:(NSString *)log;

@end

// 根据前缀判断是否是系统类
CG_INLINE BOOL yh_isSystemClassByPrefix(NSString *classPrefix) {
    if ([classPrefix hasPrefix:@"UI"] ||
        [classPrefix hasPrefix:@"NS"] ||
        [classPrefix hasPrefix:@"__NS"] ||
        [classPrefix hasPrefix:@"OS_xpc"]) {
        return YES;
    }
    
    return NO;
}

// 根据Class判断是否是系统类
CG_INLINE BOOL yh_isSystemClass(Class cls) {
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    if (mainBundle == [NSBundle mainBundle]) {
        return NO;
    }
    
    NSString *className = NSStringFromClass(cls);
    return yh_isSystemClassByPrefix(className);
}

// 根据类名称判断是否是系统类
CG_INLINE BOOL yh_isSystemClassWithClassName(NSString *clsName) {
    Class cls = NSClassFromString(clsName);
    return yh_isSystemClass(cls);
}

NS_ASSUME_NONNULL_END
