//
//  AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "AvoidCrash.h"
#import "YHBadAccessManager.h"

@implementation AvoidCrash

+ (void)load {
//#if defined(POD_CONFIGURATION_RELEASE) || defined(RELEASE)
    [self startAvoidCrashProtect];
//#endif
}

+ (void)startAvoidCrashProtect {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject avoidCrashExchangeMethod];
        
        [NSArray avoidCrashExchangeMethod];
        [NSMutableArray avoidCrashExchangeMethod];
        
        [NSDictionary avoidCrashExchangeMethod];
        [NSMutableDictionary avoidCrashExchangeMethod];
        
        [NSString avoidCrashExchangeMethod];
        [NSMutableString avoidCrashExchangeMethod];
        
        [NSAttributedString avoidCrashExchangeMethod];
        [NSMutableAttributedString avoidCrashExchangeMethod];
    });
}

+ (void)yh_avoidCrashWithObserver:(id)observer selector:(SEL)aSelector {
    if(aSelector == nil) return;
    
    // 监听通知, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:AvoidCrashNotification object:nil];
}

+ (void)yh_setupHandleDeallocClassNames:(NSArray<NSString *> *)classNames {
    [YHBadAccessManager setupHandleDeallocClassNames:classNames];
}

+ (void)yh_setupHandleDeallocClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    [YHBadAccessManager setupHandleDeallocClassPrefixs:classPrefixs];
}

@end
