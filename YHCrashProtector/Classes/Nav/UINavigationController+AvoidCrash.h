//
//  UINavigationController+AvoidCrash.h
//  YHAvoidCrash
//
//  Created by 颜琥 on 2021/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (AvoidCrash)

/// Avoid Can't Add Self as Subview Crash
+ (void)yh_enabledAvoidNoAddSelfAsSubviewCrash;

@end

NS_ASSUME_NONNULL_END
