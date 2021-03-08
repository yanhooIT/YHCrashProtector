//
//  NSObject+KVOCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import "YHKVOProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVOCrash)

@property (nonatomic, strong) YHKVOProxy *kvoProxy;

+ (void)yh_enabledAvoidKVOCrash;

@end

NS_ASSUME_NONNULL_END
