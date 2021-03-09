//
//  YHAvoidUtils.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHAvoidUtils.h"
#import <objc/runtime.h>

#define key_errorName        @"errorName"
#define key_errorReason      @"errorReason"
#define key_errorPlace       @"errorPlace"
#define key_defaultToDo      @"defaultToDo"
#define key_callStackSymbols @"callStackSymbols"
#define key_exception        @"exception"

@implementation YHAvoidUtils

+ (void)yh_swizzleClassMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    Class metaClass;
    if (class_isMetaClass(anClass)) {// 判断当前类是否为元类对象
        metaClass = anClass;
    } else {
        metaClass = object_getClass(anClass);
    }
    
    [self _swizzleMethod:metaClass oldMethod:oldMethod newMethod:newMethod];
}

+ (void)yh_swizzleInstanceMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    [self _swizzleMethod:anClass oldMethod:oldMethod newMethod:newMethod];
}

+ (void)_swizzleMethod:(Class)cls oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    Method originalMethod = class_getInstanceMethod(cls, oldMethod);
    Method swizzledMethod = class_getInstanceMethod(cls, newMethod);
    /** 通过添加方法的方式判断原方法是否存在
     
     （1）如果返回YES
     说明方法添加成功，也说明了源方法不存在，这时源方法的实现已经指向了我们自定义的方法，所以接下来只需要将新方法的实现指向源方法的实现即可，这里使用到了 class_replaceMethod 这个方法，此方法内部实现会调用 class_addMethod 和 method_setImplementation 这两个函数。

     （2）如果返回NO
     说明方法添加失败，说明源方法已经存在，直接将两个方法的实现交换即可。
     */
    BOOL didAddMethod = class_addMethod(cls, oldMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, newMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)yh_reportErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo {
    if (nil == exception) return;
    
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
    NSString *errorPlace = [NSString stringWithFormat:@"Error Place: %@", mainCallStackSymbolMsg];
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n%@\n%@\n%@\n\n",  errorName, errorReason, errorPlace, defaultToDo];
    NSLog(@"CrashProtector - %@", logErrorMessage);
    
    NSMutableDictionary *errInfoDic = [NSMutableDictionary dictionary];
    errInfoDic[key_errorName] = errorName;
    errInfoDic[key_errorReason] = errorReason;
    errInfoDic[key_errorPlace] = errorPlace;
    errInfoDic[key_defaultToDo] = defaultToDo;
    errInfoDic[key_exception] = exception;
    errInfoDic[key_callStackSymbols] = callStackSymbolsArr;
    
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YHAvoidCrashNotification object:nil userInfo:errInfoDic.copy];
    });
}

+ (void)yh_reportErrorWithLog:(NSString *)log {
    if (YH_STRING_IS_EMPTY(log)) return;
    
    log = [NSString stringWithFormat:@"[YH] - %@", log];
    
    NSLog(@"CrashProtector - %@", log);
    
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YHAvoidCrashNotification object:nil userInfo:@{key_errorReason:log}];
    });
}

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
