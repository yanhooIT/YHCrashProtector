//
//  NSMutableAttributedString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableAttributedString+AvoidCrash.h"
#import "YHAvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */

@implementation NSMutableAttributedString (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        
        // initWithString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteMutableAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(avoidCrashInitWithString:)];
        
        // initWithString:attributes:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteMutableAttributedString oldMethod:@selector(initWithString:attributes:) newMethod:@selector(avoidCrashInitWithString:attributes:)];
    });
}

#pragma mark - initWithString:
- (instancetype)avoidCrashInitWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self avoidCrashInitWithString:str];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultTodoReturnNil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:
- (instancetype)avoidCrashInitWithString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs {
    id object = nil;
    @try {
        object = [self avoidCrashInitWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultTodoReturnNil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

@end
