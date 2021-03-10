//
//  NSString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSString+AvoidCrash.h"
#import "YHAvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1. - (unichar)characterAtIndex:(NSUInteger)index
 *  2. - (NSString *)substringFromIndex:(NSUInteger)from
 *  3. - (NSString *)substringToIndex:(NSUInteger)to {
 *  4. - (NSString *)substringWithRange:(NSRange)range {
 *  5. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
 *  6. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
 *  7. - (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
 */

@implementation NSString (AvoidCrash)

+ (void)yh_enabledAvoidStringCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFConstantString");
        
        // characterAtIndex
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(characterAtIndex:) newMethod:@selector(yh_characterAtIndex:)];
        
        // substringFromIndex
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(substringFromIndex:) newMethod:@selector(yh_substringFromIndex:)];
        
        // substringToIndex
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(substringToIndex:) newMethod:@selector(yh_substringToIndex:)];
        
        // substringWithRange:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(substringWithRange:) newMethod:@selector(yh_substringWithRange:)];
        
        // stringByReplacingOccurrencesOfString:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:) newMethod:@selector(yh_stringByReplacingOccurrencesOfString:withString:)];
        
        // stringByReplacingOccurrencesOfString:withString:options:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) newMethod:@selector(yh_stringByReplacingOccurrencesOfString:withString:options:range:)];
        
        // stringByReplacingCharactersInRange:withString:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(stringByReplacingCharactersInRange:withString:) newMethod:@selector(yh_stringByReplacingCharactersInRange:withString:)];
    });
}

#pragma mark - characterAtIndex:
- (unichar)yh_characterAtIndex:(NSUInteger)index {
    unichar characteristic;
    @try {
        characteristic = [self yh_characterAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to return a without assign unichar.";
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return characteristic;
    }
}

#pragma mark - substringFromIndex:
- (NSString *)yh_substringFromIndex:(NSUInteger)from {
    NSString *subString = nil;
    @try {
        subString = [self yh_substringFromIndex:from];
    } @catch (NSException *exception) {
        subString = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return subString;
    }
}

#pragma mark - substringToIndex
- (NSString *)yh_substringToIndex:(NSUInteger)to {
    NSString *subString = nil;
    @try {
        subString = [self yh_substringToIndex:to];
    } @catch (NSException *exception) {
        subString = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return subString;
    }
}

#pragma mark - substringWithRange:
- (NSString *)yh_substringWithRange:(NSRange)range {
    NSString *subString = nil;
    @try {
        subString = [self yh_substringWithRange:range];
    } @catch (NSException *exception) {
        subString = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return subString;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:
- (NSString *)yh_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self yh_stringByReplacingOccurrencesOfString:target withString:replacement];
    } @catch (NSException *exception) {
        newStr = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return newStr;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)yh_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *newStr = nil;
    @try {
        newStr = [self yh_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        newStr = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return newStr;
    }
}

#pragma mark - stringByReplacingCharactersInRange:withString:
- (NSString *)yh_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self yh_stringByReplacingCharactersInRange:range withString:replacement];
    } @catch (NSException *exception) {
        newStr = nil;
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoReturnNil];
    } @finally {
        return newStr;
    }
}

@end
