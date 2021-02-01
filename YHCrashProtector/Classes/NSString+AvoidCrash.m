//
//  NSString+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/10/5.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSString+AvoidCrash.h"
#import "AvoidUtils.h"

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
 *
 */

@implementation NSString (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFConstantString");
        
        // characterAtIndex
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(characterAtIndex:) newMethod:@selector(avoidCrashCharacterAtIndex:)];
        
        // substringFromIndex
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(substringFromIndex:) newMethod:@selector(avoidCrashSubstringFromIndex:)];
        
        // substringToIndex
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(substringToIndex:) newMethod:@selector(avoidCrashSubstringToIndex:)];
        
        // substringWithRange:
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(substringWithRange:) newMethod:@selector(avoidCrashSubstringWithRange:)];
        
        // stringByReplacingOccurrencesOfString:
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:) newMethod:@selector(avoidCrashStringByReplacingOccurrencesOfString:withString:)];
        
        // stringByReplacingOccurrencesOfString:withString:options:range:
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) newMethod:@selector(avoidCrashStringByReplacingOccurrencesOfString:withString:options:range:)];
        
        // stringByReplacingCharactersInRange:withString:
        [AvoidUtils exchangeInstanceMethod:stringClass oldMethod:@selector(stringByReplacingCharactersInRange:withString:) newMethod:@selector(avoidCrashStringByReplacingCharactersInRange:withString:)];
    });
}

#pragma mark - characterAtIndex:
- (unichar)avoidCrashCharacterAtIndex:(NSUInteger)index {
    unichar characteristic;
    @try {
        characteristic = [self avoidCrashCharacterAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to return a without assign unichar.";
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return characteristic;
    }
}

#pragma mark - substringFromIndex:
- (NSString *)avoidCrashSubstringFromIndex:(NSUInteger)from {
    NSString *subString = nil;
    @try {
        subString = [self avoidCrashSubstringFromIndex:from];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

#pragma mark - substringToIndex
- (NSString *)avoidCrashSubstringToIndex:(NSUInteger)to {
    NSString *subString = nil;
    @try {
        subString = [self avoidCrashSubstringToIndex:to];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

#pragma mark - substringWithRange:
- (NSString *)avoidCrashSubstringWithRange:(NSRange)range {
    NSString *subString = nil;
    @try {
        subString = [self avoidCrashSubstringWithRange:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:
- (NSString *)avoidCrashStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self avoidCrashStringByReplacingOccurrencesOfString:target withString:replacement];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)avoidCrashStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *newStr = nil;
    @try {
        newStr = [self avoidCrashStringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

#pragma mark - stringByReplacingCharactersInRange:withString:
- (NSString *)avoidCrashStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self avoidCrashStringByReplacingCharactersInRange:range withString:replacement];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

@end
