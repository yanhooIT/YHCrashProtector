//
//  NSAttributedString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSAttributedString+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSAttributedString (AvoidCrash)

+ (void)yh_enabledAvoidAttributedStringCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        // initWithString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(yh_initWithString:)];
        
        // initWithAttributedString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithAttributedString:) newMethod:@selector(yh_initWithAttributedString:)];
        
        // initWithString:attributes:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:attributes:) newMethod:@selector(yh_initWithString:attributes:)];
    });
}

- (instancetype)yh_initWithString:(NSString *)str {
    id instance = nil;
    
    @try {
        if (nil == str) {
            NSString *log = [self _formatLogWithSEL:@"initWithString:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_initWithString:str];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (instancetype)yh_initWithAttributedString:(NSAttributedString *)attrStr {
    id instance = nil;
    
    @try {
        if (nil == attrStr) {
            NSString *log = [self _formatLogWithSEL:@"initWithAttributedString:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_initWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (instancetype)yh_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    id instance = nil;
    
    @try {
        if (nil == str) {
            NSString *log = [self _formatLogWithSEL:@"initWithString:attributes:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

- (NSString *)_formatLogWithSEL:(NSString *)sel error:(NSString *)error {
    return [YHAvoidLogger yh_logFormat:@"- [%@ - %@]: %@", NSStringFromClass(self.class), sel, error];
}

@end
