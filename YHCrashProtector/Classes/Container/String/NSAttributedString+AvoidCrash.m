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
        // initWithAttributedString会转调initWithString:，所以此方法无需hook
        // initWithString:attributes:会转调initWithString:，所以此方法无需hook
        [YHAvoidUtils yh_swizzleInstanceMethod:NSConcreteAttributedString oldMethod:@selector(initWithString:) newMethod:@selector(yh_initWithString:)];
    });
}

- (instancetype)yh_initWithString:(NSString *)str {
    if (nil == str) {
        NSString *log = [self _formatLogWithSEL:@"initWithString:" error:@"nil argument"];
        [YHAvoidUtils yh_reportError:log];
        return nil;
    }
    
    return [self yh_initWithString:str];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel error:(NSString *)error {
    return [NSString stringWithFormat:@"- [%@ - %@]: %@", NSStringFromClass(self.class), sel, error];
}

@end
