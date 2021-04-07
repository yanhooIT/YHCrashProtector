//
//  NSObject+KVOCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AvoidKVOCrashFlagKey "YH_KVO_PROTECTOR_FLAG"

@interface NSObject (KVOCrash)

+ (void)yh_enabledAvoidKVOCrash;

/**
 *  初始化一个需要防止 KVO 的崩溃的类名前缀的数组
 *
 *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classPrefixs数组中
 *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classPrefixs数组中
 */
+ (void)setupHandleKVOCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs;

/// 移除【被观察对象】上的所有【观察对象】
- (void)yh_removeAllObservers;

@end

NS_ASSUME_NONNULL_END
