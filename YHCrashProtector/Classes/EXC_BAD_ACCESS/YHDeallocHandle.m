//
//  YHDeallocHandle.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/22.
//

#import "YHDeallocHandle.h"
#import <objc/runtime.h>
#import "YHZoombie.h"

@implementation YHDeallocHandle

/**
 参考了系统在Object-C Runtime 中NSZombies实现，dealloc最后会调到objectdispose函数，在这个函数里面 其实也做了三件事情:
 
 1、调用objc_destructInstance释放该实例引用的相关实例（objc_destructInstance会释放与实例相关联的引用，但是并不释放该实例等内存）
 2、将该实例的isa修改为stubClass，接受任意方法调用
 3、释放该内存
 */
+ (void)handleDeallocObject:(id)obj {
    // 第一步：ARC环境下不允许调用，需要添加编译指令-fno-objc-arc
    objc_destructInstance(obj);
    
    // 将原有类名存储在关联对象中
    NSString *originClassName = NSStringFromClass([obj class]);
    objc_setAssociatedObject(obj, "originClassName", originClassName, OBJC_ASSOCIATION_COPY_NONATOMIC);

    // 第二步：将object的isa指向YHZoombie类
    object_setClass(obj, [YHZoombie class]);
}

@end
