//
//  NSObject+BadAccessCrash.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import <Foundation/Foundation.h>
#import "YHBadAccessManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BadAccessCrash)

+ (void)enabledAvoidBadAccessCrash;

@end

NS_ASSUME_NONNULL_END
