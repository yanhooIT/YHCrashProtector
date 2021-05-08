//
//  YHAvoidUtils.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHAvoidUtils.h"
#import <objc/runtime.h>

#define key_errorName        @"errorName"
#define key_errorReason      @"errorReason"
#define key_errorPlace       @"errorPlace"
#define key_defaultToDo      @"defaultToDo"
#define key_callStackSymbols @"callStackSymbols"
#define key_exception        @"exception"

@implementation YHAvoidUtils

+ (void)yh_swizzleClassMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    Class metaClass;
    if (class_isMetaClass(anClass)) {// 判断当前类是否为元类对象
        metaClass = anClass;
    } else {
        metaClass = object_getClass(anClass);
    }
    
    [self _swizzleMethod:metaClass oldMethod:oldMethod newMethod:newMethod];
}

+ (void)yh_swizzleInstanceMethod:(Class)anClass oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    [self _swizzleMethod:anClass oldMethod:oldMethod newMethod:newMethod];
}

+ (void)_swizzleMethod:(Class)cls oldMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    Method originalMethod = class_getInstanceMethod(cls, oldMethod);
    Method swizzledMethod = class_getInstanceMethod(cls, newMethod);
    /**
     class_addMethod尝试给当前类添加oldMethod这个方法，实现采取的是swizzledMethod的实现，
     这么做的目的是为了确保当前类一定有oldMethod这个方法名（否则使用method_exchangeImplementations交换不会成功）
     
     （1）如果返回YES
     说明方法添加成功，接下来只需要将新方法的实现指向源方法的实现即可，
     这里使用到了 class_replaceMethod 这个方法，此方法内部实现会调用 class_addMethod 和 method_setImplementation 这两个函数。

     （2）如果返回NO
     说明当前类中已经存在此方法，直接将两个方法的实现交换即可。
     */
    BOOL didAddMethod = class_addMethod(cls, oldMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, newMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (BOOL)yh_isSystemClassWithPrefix:(NSString *)classPrefix {
    if ([classPrefix hasPrefix:@"NS"]
        || [classPrefix hasPrefix:@"__NS"]
        || [classPrefix hasPrefix:@"UI"]
        || [classPrefix hasPrefix:@"OS_xpc"])
    {
        return YES;
    }
    
    return NO;
}

/// 根据Class判断是否是系统类
+ (BOOL)yh_isSystemClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    BOOL isSystem = [self yh_isSystemClassWithPrefix:className];
    if (isSystem) return YES;
    
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    return !(mainBundle == [NSBundle mainBundle]);
}

/// 判断selector有几个参数
+ (NSUInteger)yh_selectorArgumentCount:(SEL)selector {
    NSUInteger argumentCount = 0;
    // sel_getName获取selector名的C字符串
    const char *selectorStringCursor = sel_getName(selector);
    // 遍历字符串有几个:来确定有几个参数
    char ch;
    while((ch = *selectorStringCursor)) {
        if (ch == ':') {
            ++argumentCount;
        }

        ++selectorStringCursor;
    }
    
    return argumentCount;
}

@end
