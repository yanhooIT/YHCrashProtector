//
//  YHAvoidUtils.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define YHAvoidCrashNotification @"YHAvoidCrashNotification"

// 版本检查，version为float数据类型
#define YHAvoidCrashiOSVersionGreaterThanOrEqualTo(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

// ignore below define
#define YHAvoidCrashDefaultReturnNil  @"AvoidCrash default is to return nil to avoid crash."
#define YHAvoidCrashDefaultIgnore     @"AvoidCrash default is to ignore this operation to avoid crash."

// 互斥锁
#define YHLock()    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define YHUnlock()  dispatch_semaphore_signal(self->_lock)

@interface YHAvoidUtils : NSObject

/**
 *  类方法的交换
 *
 *  @param anClass   哪个类
 *  @param oldMethod 原本的方法
 *  @param newMethod 替换后的方法
 */
+ (void)yh_swizzleClassMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/**
 *  对象方法的交换
 *
 *  @param anClass   哪个类
 *  @param oldMethod 原本的方法
 *  @param newMethod 替换后的方法
 */
+ (void)yh_swizzleInstanceMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod;

/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
+ (void)yh_noteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;

@end

// 根据前缀判断是否是系统类
CG_INLINE BOOL yh_isSystemClassPrefix(NSString *classPrefix) {
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
    return yh_isSystemClassPrefix(className);
}

// 根据类名称判断是否是系统类
CG_INLINE BOOL yh_isSystemClassWithClassName(NSString *clsName) {
    Class cls = NSClassFromString(clsName);
    return yh_isSystemClass(cls);
}

NS_ASSUME_NONNULL_END
