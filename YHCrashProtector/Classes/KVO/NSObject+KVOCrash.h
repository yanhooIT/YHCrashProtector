//
//  NSObject+KVOCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import "YHAvoidCrashProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVOCrash) <YHAvoidCrashProtocol>

@end

NS_ASSUME_NONNULL_END
