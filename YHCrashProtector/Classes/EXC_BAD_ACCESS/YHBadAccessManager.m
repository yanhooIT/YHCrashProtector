//
//  YHBadAccessManager.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHBadAccessManager.h"

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

+ (BOOL)isHandleDeallocObject:(NSString *)className {
    BOOL isHandle = NO;
    for (NSString *clsName in _classNames) {
        if ([className isEqualToString:clsName]) {
            isHandle = YES;
            break;
        }
    }

    if (!isHandle) {
        for (NSString *classPrefix in _classPrefixs) {
            if ([className hasPrefix:classPrefix]) {
                isHandle = YES;
                break;
            }
        }
    }
    
    return isHandle;
}

+ (void)setupHandleDeallocClassNames:(NSArray<NSString *> *)classNames; {
    for (NSString *className in classNames) {
        if (![className hasPrefix:@"UI"] &&
            ![className hasPrefix:@"NS"] &&
            ![className isEqualToString:NSStringFromClass([NSObject class])]) {
            [_classNames addObject:className];
        }
    }
}

+ (void)setupHandleDeallocClassPrefixs:(NSArray<NSString *> *)classPrefixs {
    for (NSString *classPrefix in classPrefixs) {
        if (![classPrefix hasPrefix:@"UI"] &&
            ![classPrefix hasPrefix:@"NS"]) {
            [_classPrefixs addObject:classPrefix];
        }
    }
}

@end
