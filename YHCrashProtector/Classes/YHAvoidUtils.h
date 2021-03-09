//
//  YHAvoidUtils.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define YHAvoidCrashNotification @"YHAvoidCrashNotification"

// Avoid Crash Default Todo
#define YHAvoidCrashDefaultTodoReturnNil  @"[YH] - return nil to avoid crash."
#define YHAvoidCrashDefaultTodoIgnore     @"[YH] - ignore this operation to avoid crash."

// 互斥锁
#define YHLock()    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define YHUnlock()  dispatch_semaphore_signal(self->_lock)

#pragma mark - 判断对象是否为空
// 【字符串】是否为空（YES为空，NO不为空）
#define YH_STRING_IS_EMPTY(str) (nil == str || [str isKindOfClass:[NSNull class]] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1)
// 【数组】是否为空（YES为空，NO不为空）
#define YH_ARRAY_IS_EMPTY(array) (nil == array || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 【字典】是否为空（YES为空，NO不为空）
#define YH_DICT_IS_EMPTY(dict) (nil == dict || [dict isKindOfClass:[NSNull class]] || dict.allKeys.count == 0)
// 是否是空对象（YES为空，NO不为空）
#define YH_OBJECT_IS_EMPTY(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

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
