//
//  AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "AvoidCrash.h"

@implementation AvoidCrash

+ (void)load {
#if defined(POD_CONFIGURATION_RELEASE) || defined(RELEASE)
    [self startAvoidCrashProtect];
#endif
    
    [self startAvoidCrashProtect];
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

+ (void)ac_avoidCrashWithObserver:(id)observer selector:(SEL)aSelector {
    if(aSelector == nil) return;
    
    // 监听通知, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:AvoidCrashNotification object:nil];
}

+ (void)ac_setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings {
    [NSObject setupNoneSelClassStringsArr:classStrings];
}

+ (void)ac_setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs {
    [NSObject setupNoneSelClassStringPrefixsArr:classStringPrefixs];
}

+ (void)crashTest {
#if DEBUG
    NSString *str = nil;
    
    // 1、数组越界检查
    // *** -[__NSArray0 objectAtIndex:]: index 1 beyond bounds for empty NSArray
    NSArray *arr = @[];
    NSString *str1 = arr[1];
    
    // 2、数组里设置nil
    // *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    // *** -[__NSSingleObjectArrayI objectAtIndex:]: index 1 beyond bounds [0 .. 0]
    NSArray *arr2 = @[@"111", str];
    NSString *str2 = arr2[1];
    
    // 3、给字典设置nil（两种方式）
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict = @{@"key1":str};
    // [<__NSDictionary0 0x1c401f360> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key key2.
    [dict setValue:str forKey:@"key2"];

    // 4、unrecognized selector sent to instance for dict
    // -[NSNull objectForKeyedSubscript:]: unrecognized selector sent to instance
    NSDictionary *dict2 = (NSDictionary *)[NSNull null];
    NSString *str3 = dict2[@"key"];
    
    // 5、unrecognized selector sent to instance for array
    // -[NSNull objectAtIndexedSubscript:]: unrecognized selector sent to instance
    NSArray *arr3 = (NSArray *)[NSNull null];
    NSString *str4 = arr3[1];
    
    // crashTest: str1:(null)--str2:(null)--str3:(null)--str4:(null)
    NSLog(@"crashTest: str1:%@--str2:%@--str3:%@--str4:%@", str1, str2, str3, str4);
#endif
}

@end
