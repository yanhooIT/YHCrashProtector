//
//  AvoidCrashGuardProxy.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by chenfanfang on 2017/7/25.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import "AvoidCrashGuardProxy.h"

@implementation AvoidCrashGuardProxy

#pragma mark - 动态转发阶段动态添加方法
// 动态添加对象方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        return nil;
    }), "@@:");
    
    return YES;
}

// 动态添加类对象方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    // 通过object_getClass获取元类对象
    class_addMethod(object_getClass(self), sel, imp_implementationWithBlock(^{
        return nil;
    }), "@@:");
    
    return YES;
}

+ (id)handleObject:(id)object forwardingTargetForSelector:(SEL)aSelector {
    // 如果重写了 forwardInvocation，说明自己要处理，这里直接返回
    BOOL isOverride = [self _hasOverrideMethod:@selector(forwardInvocation:) object:object];
    if (isOverride) {
        return nil;
    }
    
    NSLog(@"[%@ %@]: unrecognized selector sent to instance %@", [object class], NSStringFromSelector(aSelector), object);
    
    // 交给代理对象处理
    return [AvoidCrashGuardProxy new];
}

// 判断 obj 是否重写了 sel 方法
+ (BOOL)_hasOverrideMethod:(SEL)sel object:(id)obj {
    /**
     通过object_getClass函数
     （1）如果obj是实例对象，取出来的就是类对象
     （2）如果obj是类对象，取出来的就是元类对象
    */
    Class cls = object_getClass(obj);
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        if (method_getName(method) == sel) {
            free(methods);
            return YES;
        }
    }
    
    free(methods);
    
    // 可能父类实现了这个 sel，一直遍历到基类 NSObject 为止
    Class superCls = [obj superclass];
    if (superCls != [NSObject class]) {
        // 递归调用判断但不包括 NSObject
        return [self _hasOverrideMethod:sel object:superCls];
    }
    
    return NO;
}

@end
