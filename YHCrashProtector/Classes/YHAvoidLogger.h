//
//  YHAvoidLogger.h
//  YHAvoidCrash
//
//  Created by 颜琥 on 2021/5/8.
//

#import <Foundation/Foundation.h>

#define AvoidCrashNotification @"AvoidCrashNotification"

// 【字符串】是否为空（YES为空，NO不为空）
#define AvoidCrash_STRING_IS_EMPTY(str) (nil == str || [str isKindOfClass:[NSNull class]] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1)

NS_ASSUME_NONNULL_BEGIN

@interface YHAvoidLogger : NSObject

/**
 *  上报被拦截的异常信息
 *
 *  @param exception   捕获到的异常
 */
+ (void)yh_reportException:(NSException *)exception;

/**
 *  上报被拦截的异常信息
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 处理该异常的默认做法
 */
+ (void)yh_reportException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;

/// 上报被拦击的错误的日志信息
/// @param errLog 日志信息
+ (void)yh_reportError:(NSString *)errLog;

/// 格式化日志
/// @param format 格式化字符串
+ (NSString *)yh_logFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

NS_ASSUME_NONNULL_END
