//
//  NSMutableAttributedString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableAttributedString+AvoidCrash.h"
#import "YHAvoidUtils.h"

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

#pragma mark - initWithString:attributes:
- (instancetype)yh_initWithString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs {
    id instance = nil;
    
    @try {
        if (nil == str) {
            NSString *log = [self _formatLogWithSEL:@"initWithString:" error:@"nil argument"];
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
