//
//  YHBadAccessManager.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHBadAccessManager : NSObject

/// 是否需要处理 Zoombie Objects 僵尸对象
/// @param cls 类对象
+ (BOOL)isEnableZoombieObjectProtectWithClass:(Class)cls;

/**
 *  初始化一个需要防止”EXC_BAD_ACCESS”的崩溃的类名数组
 *
 *  ⚠️不可将@"NSObject"加入classNames数组中
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)setupHandleDeallocClassNames:(NSArray<NSString *> *)classNames;

/**
 *  初始化一个需要防止”EXC_BAD_ACCESS”的崩溃的类名前缀的数组
 *
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)setupHandleDeallocClassPrefixs:(NSArray<NSString *> *)classPrefixs;

@end

NS_ASSUME_NONNULL_END
