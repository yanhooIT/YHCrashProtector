//
//  YHForwardingTarget.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import "YHForwardingTarget.h"

@implementation YHForwardingTarget

#pragma mark - 动态转发阶段动态添加方法
// 动态添加对象方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, (IMP)addMethod, "v@:@");
    return YES;
}

// 动态添加类对象方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    // 通过object_getClass获取元类对象
    class_addMethod(object_getClass(self), sel, (IMP)addMethod, "v@:@");
    return YES;
}

id addMethod(id self, SEL _cmd) {
    return 0;
}

+ (id)handleWithObject:(id)object forwardingTargetForSelector:(SEL)aSelector {
    // 如果重写了 forwardInvocation，说明自己要处理，这里直接返回
    BOOL isOverride = [self _hasOverrideWithObject:object selector:@selector(forwardInvocation:)];
    if (isOverride) {
        return nil;
    }
    
    NSLog(@"CP - unrecognized selector %@ sent to %@'s instance %@", NSStringFromSelector(aSelector), [object class], object);
    
    // 交给代理对象处理
    return [YHForwardingTarget new];
}

+ (BOOL)_hasOverrideWithObject:(id)obj selector:(SEL)sel {
    /**
     通过object_getClass函数
     （1）如果obj是实例对象，取出来的就是类对象
     （2）如果obj是类对象，取出来的就是元类对象
    */
    Class cls = object_getClass(obj);
    // 1、判断是否都实现
    if (class_respondsToSelector(cls, sel)) {
        IMP imp = class_getMethodImplementation(cls, sel);
        IMP impInRoot = class_getMethodImplementation([NSObject class], sel);
        // 2、排除方法在根类中实现的情况
        if (imp != impInRoot) {
            return YES;
        }
    }
    
    return NO;
}

@end
