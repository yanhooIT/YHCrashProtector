//
//  NSMutableString+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSMutableString+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSMutableString (AvoidCrash)

+ (void)yh_enabledAvoidStringMCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFString = NSClassFromString(@"__NSCFString");
        
        // insertString:atIndex:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFString oldMethod:@selector(insertString:atIndex:) newMethod:@selector(yh_insertString:atIndex:)];
        
        // replaceCharactersInRange:withString:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFString oldMethod:@selector(replaceCharactersInRange:withString:) newMethod:@selector(yh_replaceCharactersInRange:withString:)];
        
        // replaceOccurrencesOfString:withString:options:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFString oldMethod:@selector(replaceOccurrencesOfString:withString:options:range:) newMethod:@selector(yh_replaceOccurrencesOfString:withString:options:range:)];
        
        // deleteCharactersInRange
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFString oldMethod:@selector(deleteCharactersInRange:) newMethod:@selector(yh_deleteCharactersInRange:)];
        
        // stringByReplacingOccurrencesOfString:withString:options:range:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSCFString oldMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) newMethod:@selector(yh_NSCFStringstringByReplacingOccurrencesOfString:withString:options:range:)];
    });
}

- (void)yh_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        if (nil == aString) {
            NSString *log = [self _formatLogWithSEL:@"insertString:atIndex:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return;
        }
        
        if (loc < 0 || loc > self.length) {
            NSString *log = [self _formatLogWithSEL:@"insertString:atIndex:" index:loc];
            [YHAvoidLogger yh_reportError:log];
            return;
        }
        
        [self yh_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        
    }
}

- (void)yh_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        if (nil == aString) {
            NSString *log = [self _formatLogWithSEL:@"replaceCharactersInRange:withString:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return;
        }
        
        NSUInteger tmp = (range.location + range.length);
        if (tmp > self.length) {
            NSString *log = [self _formatLogWithSEL:@"replaceCharactersInRange:withString:" range:range];
            [YHAvoidLogger yh_reportError:log];
            return;
        }
        
        [self yh_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        
    }
}

- (NSUInteger)yh_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    NSUInteger count = 0;
    
    @try {
        if (nil == target || nil == replacement) {
            NSString *log = [self _formatLogWithSEL:@"replaceOccurrencesOfString:withString:options:range:" error:@"nil argument"];
            [YHAvoidLogger yh_reportError:log];
            return 0;
        }
        
        NSUInteger tmp = (searchRange.location + searchRange.length);
        if (tmp > self.length) {
            NSString *log = [self _formatLogWithSEL:@"replaceOccurrencesOfString:withString:options:range:" range:searchRange];
            [YHAvoidLogger yh_reportError:log];
            return 0;
        }
        
        count = [self yh_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return count;
    }
}

- (void)yh_deleteCharactersInRange:(NSRange)range {
    @try {
        NSUInteger tmp = (range.location + range.length);
        if (tmp > self.length) {
            NSString *log = [self _formatLogWithSEL:@"deleteCharactersInRange:" range:range];
            [YHAvoidLogger yh_reportError:log];
            return;
        }
        
        [self yh_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)yh_NSCFStringstringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
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
        
        instance = [self yh_NSCFStringstringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
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
