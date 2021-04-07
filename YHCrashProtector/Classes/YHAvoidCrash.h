//
//  YHAvoidCrash.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(POD_CONFIGURATION_RELEASE) || defined(RELEASE)
    // 开启Avoid Crash监控
    #define _INTERNAL_AVC_ENABLED 1
#else
    #define _INTERNAL_AVC_ENABLED 0
#endif

@interface YHAvoidCrash : NSObject

/// 搜集被框架避免的Crash信息（详细信息通过 NSNotification对象的 userInfo 返回），！！！此类问题收到后需要立即处理！！！
/// @param observer 监听通知的对象
/// @param aSelector 处理通知的回调，参数为NSNotification对象
+ (void)yh_avoidCrashWithObserver:(id)observer selector:(SEL)aSelector;

/**
 *  初始化一个需要防止”EXC_BAD_ACCESS”的崩溃的类名数组
 *
 *  ⚠️不可将@"NSObject"加入classNames数组中
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)yh_setupHandleExcBadAccessCrashClassNames:(NSArray<NSString *> *)classNames;

/**
 *  初始化一个需要防止”EXC_BAD_ACCESS”的崩溃的类名前缀的数组
 *
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)yh_setupHandleExcBadAccessCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs;

/**
 *  初始化一个需要防止 KVO 的崩溃的类名前缀的数组
 *
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)yh_setupHandleKVOCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs;

@end
