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
 */

@implementation NSMutableString (AvoidCrash)

+ (void)yh_enabledAvoidStringMCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFString");
        
        // replaceCharactersInRange
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(replaceCharactersInRange:withString:) newMethod:@selector(yh_replaceCharactersInRange:withString:)];
        
        // insertString:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(insertString:atIndex:) newMethod:@selector(yh_insertString:atIndex:)];
        
        // deleteCharactersInRange
        [YHAvoidUtils yh_swizzleInstanceMethod:stringClass oldMethod:@selector(deleteCharactersInRange:) newMethod:@selector(yh_deleteCharactersInRange:)];
    });
}

- (void)yh_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self yh_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoIgnore];
    } @finally {
        
    }
}

- (void)yh_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self yh_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoIgnore];
    } @finally {
        
    }
}

- (void)yh_deleteCharactersInRange:(NSRange)range {
    @try {
        [self yh_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [YHAvoidUtils yh_reportErrorWithException:exception defaultToDo:YHAvoidCrashDefaultTodoIgnore];
    } @finally {
        
    }
}

@end
