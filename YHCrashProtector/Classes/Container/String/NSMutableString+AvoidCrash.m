//
//  NSMutableString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableString+AvoidCrash.h"
#import "YHAvoidUtils.h"

/**
 *  Can avoid crash method
 *
 *  1. 由于NSMutableString是继承于NSString,所以这里和NSString有些同样的方法就不重复写了
 *  2. - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
 *  3. - (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc
 *  4. - (void)deleteCharactersInRange:(NSRange)range
 *
 */

@implementation NSMutableString (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFString");
        
        // replaceCharactersInRange
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(replaceCharactersInRange:withString:) newMethod:@selector(avoidCrashReplaceCharactersInRange:withString:)];
        
        // insertString:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(insertString:atIndex:) newMethod:@selector(avoidCrashInsertString:atIndex:)];
        
        // deleteCharactersInRange
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(deleteCharactersInRange:) newMethod:@selector(avoidCrashDeleteCharactersInRange:)];
    });
}

#pragma mark - replaceCharactersInRange
- (void)avoidCrashReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self avoidCrashReplaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - insertString:atIndex:
- (void)avoidCrashInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self avoidCrashInsertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

#pragma mark - deleteCharactersInRange
- (void)avoidCrashDeleteCharactersInRange:(NSRange)range {
    @try {
        [self avoidCrashDeleteCharactersInRange:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = YHAvoidCrashDefaultIgnore;
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
