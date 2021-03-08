//
//  NSNotificationCenter+AvoidCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AvoidNotificationCrashFlagKey "YH_Notification_PROTECTOR_FLAG"

@interface NSNotificationCenter (AvoidCrash)

+ (void)enabledAvoidNotificationCrash;

@end

NS_ASSUME_NONNULL_END
