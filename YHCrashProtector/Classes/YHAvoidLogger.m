//
//  YHAvoidLogger.m
//  YHAvoidCrash
//
//  Created by 颜琥 on 2021/5/8.
//

#import "YHAvoidLogger.h"

@implementation YHAvoidLogger

+ (void)yh_reportException:(NSException *)exception {
    [self yh_reportException:exception defaultToDo:nil];
}

+ (void)yh_reportException:(NSException *)exception defaultToDo:(NSString *)defaultToDo {
    if (nil == exception) return;
    
    if (AvoidCrash_STRING_IS_EMPTY(defaultToDo)) {
        defaultToDo = @"Avoid Crash";
    }
    
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    // 获取在哪个类的哪个方法中实例化的数组
    // 字符串格式: -[类名 方法名] or +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self _getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败, 请您查看函数调用栈来排查错误原因";
    }
    
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    // errorReason 可能为 -[__NSCFConstantString yh_characterAtIndex:]: Range or index out of bounds, 将yh_前缀去掉
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"yh_" withString:@""];
    NSString *errorPlace = [[NSString alloc] initWithFormat:@"Error Place: %@", mainCallStackSymbolMsg];
    NSString *logErrorMessage = [[NSString alloc] initWithFormat:@"\n\n%@\n%@\n%@\n%@\n\n",  errorName, errorReason, errorPlace, defaultToDo];

#if defined(POD_CONFIGURATION_DEBUG) || defined(DEBUG)
    NSLog(@"CrashProtector: %@", logErrorMessage);
#else
    NSMutableDictionary *errInfoDic = [NSMutableDictionary dictionary];
    errInfoDic[key_errorName] = errorName;
    errInfoDic[key_errorReason] = errorReason;
    errInfoDic[key_errorPlace] = errorPlace;
    errInfoDic[key_defaultToDo] = defaultToDo;
    errInfoDic[key_exception] = exception;
    errInfoDic[key_callStackSymbols] = callStackSymbolsArr;
    
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AvoidCrashNotification object:nil userInfo:errInfoDic.copy];
    });
#endif
}

+ (void)yh_reportError:(NSString *)errLog {
    if (AvoidCrash_STRING_IS_EMPTY(errLog)) return;
    
#if defined(POD_CONFIGURATION_DEBUG) || defined(DEBUG)
    NSLog(@"CrashProtector: %@", errLog);
#else
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AvoidCrashNotification object:nil userInfo:@{key_errorReason:errLog}];
    });
#endif
}

+ (NSString *)yh_logFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    // 1. 定义一个指向个数可变的参数列表指针
    va_list args;
    
    // 2. 开始初始化参数，start会从 format 中依次提取参数, 类似于类结构体中的偏移量 offset 的方式
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    
    // 3. 清空参数列表，并置参数指针args无效
    va_end(args);
    
    return str;
}

#pragma mark - Private Methods
/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)_getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols
{
    // mainCallStackSymbolMsg的格式为: +[类名 方法名] or -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    // 匹配出来的格式为: +[类名 方法名] or -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                // get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                // filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}

@end
