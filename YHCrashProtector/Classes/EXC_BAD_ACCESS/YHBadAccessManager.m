//
//  YHBadAccessManager.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHBadAccessManager.h"
#import <objc/runtime.h>
#import "YHZoombie.h"

@implementation YHBadAccessManager

+ (instancetype)sharedInstance {
    static YHBadAccessManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)handleDeallocObject:(id)object {
    // 将原有类名存储在关联对象中
    NSString *originClassName = NSStringFromClass([object class]);
    objc_setAssociatedObject(object, "originClassName", originClassName, OBJC_ASSOCIATION_COPY_NONATOMIC);

    // 指向固定的类
    object_setClass(object, [YHZoombie class]);
}

@end
