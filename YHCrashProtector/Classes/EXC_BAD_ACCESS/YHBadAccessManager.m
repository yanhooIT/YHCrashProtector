//
//  YHBadAccessManager.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHBadAccessManager.h"
#import "YHAvoidUtils.h"

@implementation YHBadAccessManager

static NSMutableArray *_classNames;
static NSMutableArray *_classPrefixs;
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _classNames = [NSMutableArray array];
        _classPrefixs = [NSMutableArray array];
    });
}

+ (BOOL)isEnableZoombieObjectProtectWithClass:(Class)cls {
    BOOL isHandle = NO;
    for (NSString *clsName in _classNames) {
        if ([cls isSubclassOfClass:NSClassFromString(clsName)]) {
            isHandle = YES;
            break;
        }
    }

    if (!isHandle && _classPrefixs.count > 0) {
        NSString *className = NSStringFromClass(cls);
        for (NSString *clsPrefix in _classPrefixs) {
            if ([className hasPrefix:clsPrefix]) {
                isHandle = YES;
                break;
            }
        }
    }
    
    return isHandle;
}

+ (void)setupHandleDeallocClassNames:(NSArray<NSString *> *)classNames; {
    for (NSString *className in classNames) {
        if (!yh_isSystemClassWithClassName(className)) {
            [_classNames addObject:className];
        }
    }
}

+ (void)setupHandleDeallocClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    for (NSString *classPrefix in classPrefixs) {
        if (!yh_isSystemClassPrefix(classPrefix)) {
            [_classPrefixs addObject:classPrefix];
        }
    }
}

@end
