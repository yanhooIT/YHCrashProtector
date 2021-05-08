//
//  NSNull+YHNullSafe.m
//  YHAvoidCrash
//
//  Created by 颜琥 on 2021/4/27.
//  确保在在给NSNull发送消息时不会Crash
//  原理分析参见：https://blog.csdn.net/donnydn/article/details/78226050

#import "NSNull+YHNullSafe.h"
#import <objc/runtime.h>

#ifndef NULLSAFE_ENABLED
    #ifdef DEBUG
        #define NULLSAFE_ENABLED 0
    #else
        #define NULLSAFE_ENABLED 1
    #endif
#endif

/** 测试Demo
 
 // 给NSNull发送length消息不会Crash
 NSString *str = [NSNull null];
 NSInteger len = str.length;
 
 // 给NSNull发送count消息不会Crash
 NSArray *arr = [NSNull null];
 NSInteger count = arr.count;
 */

@implementation NSNull (YHNullSafe)

#if NULLSAFE_ENABLED

static NSArray *_Classes;
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _Classes = @[[NSMutableArray class],
                     [NSMutableDictionary class],
                     [NSMutableString class],
                     [NSNumber class],
                     [NSDate class],
                     [NSData class]];
    });
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (Class someClass in _Classes) {
            @try {
                if ([someClass instancesRespondToSelector:selector]) {
                    signature = [someClass instanceMethodSignatureForSelector:selector];
                    break;
                }
            } @catch (__unused NSException *unused) {
                
            }
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // 将处理消息的对象置为nil，在ARC中给nil发送消息是不会崩溃的
    invocation.target = nil;
    [invocation invoke];
}

#endif

@end
