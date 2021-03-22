//
//  NSObject+UnSELCrash.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/5.
//

#import "NSObject+UnSELCrash.h"
#import "YHAvoidUtils.h"
#import "YHForwardingTarget.h"

@implementation NSObject (UnSELCrash)

+ (void)yh_enabledAvoidUnSELCrash {
    /** Avoid "unrecognized selector sent to instance" Crash
     
     1、resolveInstanceMethod/resolveClassMethod需要在类的本身上动态添加它本身不存在的方法，这些方法对于该类本身来说冗余的
     2、forwardingTargetForSelector可以将消息转发给一个对象，开销较小，并且被重写的概率较低，适合重写
     3、forwardInvocation不适合处理unrecognized selector sent to instance Crash的说明：
     
     （1）forwardInvocation可以通过NSInvocation的形式将消息转发给多个对象，但是其开销较大，需要创建新的NSInvocation对象
     （2）forwardInvocation的函数经常被使用者调用，来做多层消息转发选择机制
     
     结论：forwardInvocation【不适合】多次重写
    
     [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(methodSignatureForSelector:) newMethod:@selector(avoidCrashMethodSignatureForSelector:)];
     [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(forwardInvocation:) newMethod:@selector(avoidCrashForwardInvocation:)];
     */
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(forwardingTargetForSelector:) newMethod:@selector(yh_forwardingTargetForSelector:)];
}

#pragma mark - Avoid "unrecognized selector sent to instance" Crash
- (id)yh_forwardingTargetForSelector:(SEL)aSelector {
    return [YHForwardingTarget handleWithObject:self forwardingTargetForSelector:aSelector];
}

@end
