//
//  NSAttributedString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSAttributedString+AvoidCrash.h"
#import "YHAvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr
 *  3.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */
@implementation NSAttributedString (AvoidCrash)

+ (void)yh_enabledAvoidAttributedStringCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        // initWithString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(yh_initWithString:)];
        
        // initWithAttributedString
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithAttributedString:) newMethod:@selector(yh_initWithAttributedString:)];
        
        // initWithString:attributes:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:attributes:) newMethod:@selector(yh_initWithString:attributes:)];
    });
}

- (instancetype)yh_initWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self yh_initWithString:str];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultTodoReturnNil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

- (instancetype)yh_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    @try {
        object = [self yh_initWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultTodoReturnNil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

- (instancetype)yh_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    @try {
        object = [self yh_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultTodoReturnNil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

@end
