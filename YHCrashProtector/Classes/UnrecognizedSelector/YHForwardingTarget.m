//
//  YHForwardingTarget.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import "YHForwardingTarget.h"
#import "YHAvoidUtils.h"

@implementation YHForwardingTarget

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - 动态转发阶段动态添加方法
// 动态添加【对象方法】
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // @@:的含义：@表示返回值为id类型，@表示id类型的参数，:表示SEL
    class_addMethod(self.class, sel, (IMP)addMethod, "@@:");
    return YES;
}

// 动态添加【类对象方法】
+ (BOOL)resolveClassMethod:(SEL)sel {
    // 通过object_getClass获取元类对象
    class_addMethod(object_getClass(self), sel, (IMP)addMethod, "@@:");
    return YES;
}

// 用一个有返回值的函数来替换，从而达到程序不崩溃的目的
// 用这种带有返回值的函数能很好的容错（能兼容无返回参数的方法和有参数返回的方法）
id addMethod(id self, SEL _cmd) {
    return nil;
}

// ^^^^^^^^^^^^^^^^ 以上为动态转发阶段【桩对象】动态添加方法的处理逻辑 ^^^^^^^^^^^^^^^^

// 返回代理对象
+ (id)handleWithObject:(id)obj forwardingTargetForSelector:(SEL)aSelector {
    id proxy = nil;
    
    @try {
        // 如果重写了 forwardInvocation，说明对象本身会处理，框架就无需干预了，直接返回nil
        BOOL isOverride = [self _hasOverrideWithObject:obj selector:@selector(forwardInvocation:)];
        if (isOverride) {
            return nil;
        }
        
        NSString *log = [[NSString alloc] initWithFormat:@"unrecognized selector \"%@\" be sent to \"%@'s\" instance", NSStringFromSelector(aSelector), NSStringFromClass([obj class])];
        [YHAvoidLogger yh_reportError:log];
        
        // 交给代理对象处理
        proxy = [YHForwardingTarget new];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return proxy;
    }
}

// 判断对象本身是否重写了 forwardInvocation 方法
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
        // 2、排除方法在根类(NSObject)中实现的情况
        if (imp != impInRoot) {
            return YES;
        }
    }
    
    return NO;
}

@end
