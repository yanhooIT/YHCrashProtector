//
//  YHForwardingTarget.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import "YHForwardingTarget.h"

@implementation YHForwardingTarget

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - 动态转发阶段动态添加方法
// 动态添加【对象方法】
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // v@:的含义：v表示无返回值，@表示id类型的参数，:表示SEL
    class_addMethod(self.class, sel, (IMP)addMethod, "v@:");
    return YES;
}

// 动态添加【类对象方法】
+ (BOOL)resolveClassMethod:(SEL)sel {
    // 通过object_getClass获取元类对象
    class_addMethod(object_getClass(self), sel, (IMP)addMethod, "v@:");
    return YES;
}

// 用一个返回为空的函数来替换，从而达到程序不崩溃的目的
void addMethod(id self, SEL _cmd) { }

// ^^^^^^^^^^^^^^^^ 以上为动态转发阶段【桩对象】动态添加方法的处理逻辑 ^^^^^^^^^^^^^^^^

// 返回代理对象
+ (id)handleWithObject:(id)obj forwardingTargetForSelector:(SEL)aSelector {
    // 如果重写了 forwardInvocation，说明对象本身要处理，这里直接返回
    BOOL isOverride = [self _hasOverrideWithObject:obj selector:@selector(forwardInvocation:)];
    if (isOverride) {
        return nil;
    }
    
    NSLog(@"CrashProtector - unrecognized selector \"%@\" be sent to \"%@'s\" instance", NSStringFromSelector(aSelector), NSStringFromClass([obj class]));
    
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
