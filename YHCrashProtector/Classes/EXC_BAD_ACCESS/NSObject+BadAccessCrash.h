//
//  NSObject+BadAccessCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import <Foundation/Foundation.h>
#import "YHBadAccessManager.h"

NS_ASSUME_NONNULL_BEGIN

#define AvoidBadAccessCrashFlagKey "YH_EXC_BAD_ACCESS_PROTECTOR_FLAG"

@interface NSObject (BadAccessCrash)

+ (void)enabledAvoidBadAccessCrash;

@end

NS_ASSUME_NONNULL_END
