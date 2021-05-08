//
//  NSString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSString+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSString (AvoidCrash)

+ (void)yh_enabledAvoidStringCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSPlaceholderString = NSClassFromString(@"NSPlaceholderString");
        Class __NSCFConstantString = NSClassFromString(@"__NSCFConstantString");
        
        // initWithString:
        [YHAvoidUtils yh_swizzleInstanceMethod:NSPlaceholderString oldMethod:@selector(initWithString:) newMethod:@selector(yh_initWithString:)];
        
        // hasPrefix:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(hasPrefix:) newMethod:@selector(yh_hasPrefix:)];
        
        // hasSuffix:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(hasSuffix:) newMethod:@selector(yh_hasSuffix:)];
        
        // characterAtIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(characterAtIndex:) newMethod:@selector(yh_characterAtIndex:)];
        
        // substringFromIndex
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(substringFromIndex:) newMethod:@selector(yh_substringFromIndex:)];
        
        // substringToIndex
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(substringToIndex:) newMethod:@selector(yh_substringToIndex:)];
        
        // substringWithRange:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(substringWithRange:) newMethod:@selector(yh_substringWithRange:)];
        
        // stringByReplacingOccurrencesOfString:withString:options:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFConstantString oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) newMethod:@selector(yh_NSCFConstantStringstringByReplacingOccurrencesOfString:withString:options:range:)];
    });
}

#pragma mark - initWithString:
- (instancetype)yh_initWithString:(NSString *)aString {
    id instance = nil;
    
    @try {
        if (nil == aString) {
            NSString *log = [self _formatLogWithSEL:@"initWithString:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_initWithString:aString];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - hasPrefix:
- (BOOL)yh_hasPrefix:(NSString *)str {
    BOOL hasPrefix = NO;
    
    @try {
        if (nil == str) {
            NSString *log = [self _formatLogWithSEL:@"hasPrefix:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return NO;
        }
        
        hasPrefix = [self yh_hasPrefix:str];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return hasPrefix;
    }
}

#pragma mark - hasSuffix:
- (BOOL)yh_hasSuffix:(NSString *)str {
    BOOL hasSuffix = NO;
    
    @try {
        if (nil == str) {
            NSString *log = [self _formatLogWithSEL:@"hasSuffix:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return NO;
        }
        
        hasSuffix = [self yh_hasSuffix:str];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return hasSuffix;
    }
}

#pragma mark - characterAtIndex:
- (unichar)yh_characterAtIndex:(NSUInteger)index {
    unichar characteristic = 0;
    
    @try {
        if (index >=0 && index < self.length) {
            characteristic = [self yh_characterAtIndex:index];
        } else {
            NSString *log = [self _formatLogWithSEL:@"characterAtIndex:" error:@"Range or index out of bounds"];
            [YHAvoidLogger yh_reportError:log];
        }
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return characteristic;
    }
}

#pragma mark - substringFromIndex:
- (NSString *)yh_substringFromIndex:(NSUInteger)from {
    id instance = nil;
    
    @try {
        if (from < 0 || from > self.length) {
            NSString *log = [self _formatLogWithSEL:@"substringFromIndex:" index:from];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_substringFromIndex:from];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - substringToIndex:
- (NSString *)yh_substringToIndex:(NSUInteger)to {
    id instance = nil;
    
    @try {
        if (to < 0 || to > self.length) {
            NSString *log = [self _formatLogWithSEL:@"substringToIndex:" index:to];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_substringToIndex:to];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - substringWithRange:
- (NSString *)yh_substringWithRange:(NSRange)range {
    id instance = nil;
    
    @try {
        NSUInteger tmp = (range.location + range.length);
        if (tmp > self.length) {
            NSString *log = [self _formatLogWithSEL:@"substringWithRange:" range:range];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_substringWithRange:range];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)yh_NSCFConstantStringstringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    id instance = nil;
    
    @try {
        if (nil == target || nil == replacement) {
            NSString *log = [self _formatLogWithSEL:@"stringByReplacingOccurrencesOfString:withString:options:range:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        NSUInteger tmp = (searchRange.location + searchRange.length);
        if (tmp > self.length) {
            NSString *log = [self _formatLogWithSEL:@"stringByReplacingOccurrencesOfString:withString:options:range:" range:searchRange];
            [YHAvoidLogger yh_reportError:log];
            return nil;
        }
        
        instance = [self yh_NSCFConstantStringstringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - Log
- (NSString *)_formatLogWithSEL:(NSString *)sel index:(NSUInteger)index {
    return [YHAvoidLogger yh_logFormat:@"- [%@ - %@]: Index %ld out of bounds; string length %ld", NSStringFromClass(self.class), sel, index, self.length];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel range:(NSRange)range {
    return [YHAvoidLogger yh_logFormat:@"- [%@ - %@]: Range {%ld, %ld} out of bounds; string length %ld", NSStringFromClass(self.class), sel, range.location, range.length, self.length];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel error:(NSString *)error {
    return [YHAvoidLogger yh_logFormat:@"- [%@ - %@]: %@", NSStringFromClass(self.class), sel, error];
}

@end
