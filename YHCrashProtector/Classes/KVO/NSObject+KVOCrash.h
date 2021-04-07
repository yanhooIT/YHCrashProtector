//
//  NSObject+KVOCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import "YHKVOProxy.h"

NS_ASSUME_NONNULL_BEGIN

#define AvoidKVOCrashFlagKey "YH_KVO_PROTECTOR_FLAG"

@interface NSObject (KVOCrash)

+ (void)yh_enabledAvoidKVOCrash;

/// 移除【被观察对象】上的所有【观察对象】
- (void)yh_removeAllObservers;

@end

NS_ASSUME_NONNULL_END
