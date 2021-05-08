//
//  YHAvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "YHAvoidCrash.h"
#import "YHAvoidUtils.h"

#import "NSObject+BadAccessCrash.h"

#import "NSObject+UnSELCrash.h"

#import "NSObject+KVOCrash.h"
#import "YHKVOProxy.h"

#import "NSObject+KVCCrash.h"

#import "NSNotificationCenter+AvoidCrash.h"

#import "NSTimer+AvoidCrash.h"

#import "NSArray+AvoidCrash.h"
#import "NSMutableArray+AvoidCrash.h"

#import "NSDictionary+AvoidCrash.h"
#import "NSMutableDictionary+AvoidCrash.h"

#import "NSString+AvoidCrash.h"
#import "NSMutableString+AvoidCrash.h"

#import "NSAttributedString+AvoidCrash.h"
#import "NSMutableAttributedString+AvoidCrash.h"

#import "UINavigationController+AvoidCrash.h"

@implementation YHAvoidCrash

+ (void)load {
#if _INTERNAL_AVC_ENABLED
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startAvoidCrashProtect];
    });
#endif
}

+ (void)startAvoidCrashProtect {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 启用 Avoid 野指针 Crash
//        [NSObject yh_enabledAvoidBadAccessCrash];
        
        // 启用 Avoid "unrecognized selector sent to instance" Crash
        [NSObject yh_enabledAvoidUnSELCrash];
        
        // 启用 Avoid KVO Crash
        [NSObject yh_enabledAvoidKVOCrash];
        
        // 启用 Avoid KVC Crash
        [NSObject yh_enabledAvoidKVCCrash];
        
        // 启用 Avoid 通知 Crash
        [NSNotificationCenter yh_enabledAvoidNotificationCrash];
        
        // 启用 Avoid Timer Crash
        [NSTimer yh_enabledAvoidTimerCrash];
        
        // 启用 Avoid Array Crash
        [NSArray yh_enabledAvoidArrayCrash];
        [NSMutableArray yh_enabledAvoidArrayMCrash];
        
        // 启用 Avoid Dictionary Crash
        [NSDictionary yh_enabledAvoidDictionaryCrash];
        [NSMutableDictionary yh_enabledAvoidDictionaryMCrash];
        
        // 启用 Avoid String Crash
        [NSString yh_enabledAvoidStringCrash];
        [NSMutableString yh_enabledAvoidStringMCrash];
        
        // 启用 Avoid AttributedString Crash
        [NSAttributedString yh_enabledAvoidAttributedStringCrash];
        [NSMutableAttributedString yh_enabledAvoidAttributedStringMCrash];
        
        // 启用 Avoid Can't Add Self as Subview Crash
//        [UINavigationController yh_enabledAvoidNoAddSelfAsSubviewCrash];
    });
}

+ (void)yh_avoidCrashWithObserver:(id)observer selector:(SEL)aSelector {
#if _INTERNAL_AVC_ENABLED
    if(aSelector == nil) return;
    
    // 监听通知, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:AvoidCrashNotification object:nil];
#endif
}

+ (void)yh_setupHandleExcBadAccessCrashClassNames:(NSArray<NSString *> *)classNames {
#if _INTERNAL_AVC_ENABLED
    [YHBadAccessManager setupHandleDeallocClassNames:classNames];
#endif
}

+ (void)yh_setupHandleExcBadAccessCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs {
#if _INTERNAL_AVC_ENABLED
    [YHBadAccessManager setupHandleDeallocClassPrefixs:classPrefixs];
#endif
}

+ (void)yh_setupHandleKVOCrashClassPrefixs:(NSArray<NSString *> *)classPrefixs {
#if _INTERNAL_AVC_ENABLED
    [NSObject setupHandleKVOCrashClassPrefixs:classPrefixs];
#endif
}

@end
