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

+ (void)yh_enabledAvoidAttributedStringMCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        // initWithString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteMutableAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(yh_initWithString:)];
        
        // initWithString:attributes:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteMutableAttributedString oldMethod:@selector(initWithString:attributes:) newMethod:@selector(yh_initWithString:attributes:)];
    });
}

#pragma mark - initWithString:
- (instancetype)yh_initWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self yh_initWithString:str];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:
- (instancetype)yh_initWithString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs {
    id object = nil;
    @try {
        object = [self yh_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return object;
    }
}

@end
