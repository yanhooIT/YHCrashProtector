//
//  NSAttributedString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSAttributedString+AvoidCrash.h"
#import "AvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr
 *  3.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 *
 */

@implementation NSAttributedString (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        // initWithString:
        [AvoidUtils exchangeInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(avoidCrashInitWithString:)];
        
        // initWithAttributedString
        [AvoidUtils exchangeInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithAttributedString:) newMethod:@selector(avoidCrashInitWithAttributedString:)];
        
        // initWithString:attributes:
        [AvoidUtils exchangeInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:attributes:) newMethod:@selector(avoidCrashInitWithString:attributes:)];
    });
}

#pragma mark - initWithString:
- (instancetype)avoidCrashInitWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self avoidCrashInitWithString:str];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - initWithAttributedString
- (instancetype)avoidCrashInitWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    @try {
        object = [self avoidCrashInitWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:
- (instancetype)avoidCrashInitWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    @try {
        object = [self avoidCrashInitWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

@end
