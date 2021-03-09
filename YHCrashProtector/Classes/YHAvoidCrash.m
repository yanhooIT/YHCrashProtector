//
//  YHAvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "YHAvoidCrash.h"
#import "YHAvoidUtils.h"

// Avoid "unrecognized selector sent to instance" Crash
#import "NSObject+UnSELCrash.h"
// Avoid 野指针 Crash
#import "NSObject+BadAccessCrash.h"
// Avoid KVO Crash
#import "NSObject+KVOCrash.h"
// Avoid KVC Crash
#import "NSObject+KVCCrash.h"
// Avoid 通知 Crash
#import "NSNotificationCenter+AvoidCrash.h"
// Avoid Timer Crash
#import "NSTimer+AvoidCrash.h"
// Avoid Array Crash
#import "NSArray+AvoidCrash.h"
#import "NSMutableArray+AvoidCrash.h"
// Avoid Dictionary Crash
#import "NSDictionary+AvoidCrash.h"
#import "NSMutableDictionary+AvoidCrash.h"
// Avoid String Crash
#import "NSString+AvoidCrash.h"
#import "NSMutableString+AvoidCrash.h"
#import "NSAttributedString+AvoidCrash.h"
#import "NSMutableAttributedString+AvoidCrash.h"

@implementation YHAvoidCrash

+ (void)load {
//#if defined(POD_CONFIGURATION_RELEASE) || defined(RELEASE)
    [self startAvoidCrashProtect];
//#endif
}

+ (void)startAvoidCrashProtect {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject yh_enabledAvoidUnSELCrash];
        [NSObject yh_enabledAvoidBadAccessCrash];
        [NSObject yh_enabledAvoidKVOCrash];
        [NSObject yh_enabledAvoidKVCCrash];
        [NSNotificationCenter yh_enabledAvoidNotificationCrash];
        [NSTimer yh_enabledAvoidTimerCrash];
        
        [NSArray yh_enabledAvoidArrayCrash];
        [NSMutableArray yh_enabledAvoidArrayMCrash];

//        [NSDictionary yh_enabledAvoidDictionaryCrash];
//        [NSMutableDictionary yh_enabledAvoidDictionaryMCrash];
  
//        [NSString avoidCrashExchangeMethod];
//        [NSMutableString avoidCrashExchangeMethod];
//        [NSAttributedString avoidCrashExchangeMethod];
//        [NSMutableAttributedString avoidCrashExchangeMethod];
    });
}

+ (void)yh_avoidCrashWithObserver:(id)observer selector:(SEL)aSelector {
    if(aSelector == nil) return;
    
    // 监听通知, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:YHAvoidCrashNotification object:nil];
}

+ (void)yh_setupHandleDeallocClassNames:(NSArray<NSString *> *)classNames {
    [YHBadAccessManager setupHandleDeallocClassNames:classNames];
}

+ (void)yh_setupHandleDeallocClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    [YHBadAccessManager setupHandleDeallocClassPrefixs:classPrefixs];
}

@end
