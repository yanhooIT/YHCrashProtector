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
    if (nil == aString) {
        NSString *log = [self _formatLogWithSEL:@"insertString:atIndex:" error:@"nil argument"];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    if (loc < 0 || loc > self.length) {
        NSString *log = [self _formatLogWithSEL:@"insertString:atIndex:" index:loc];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_insertString:aString atIndex:loc];
}

- (void)yh_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if (nil == aString) {
        NSString *log = [self _formatLogWithSEL:@"replaceCharactersInRange:withString:" error:@"nil argument"];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    NSUInteger tmp = (range.location + range.length);
    if (tmp > self.length) {
        NSString *log = [self _formatLogWithSEL:@"replaceCharactersInRange:withString:" range:range];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_replaceCharactersInRange:range withString:aString];
}

- (NSUInteger)yh_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    if (nil == target || nil == replacement) {
        NSString *log = [self _formatLogWithSEL:@"replaceOccurrencesOfString:withString:options:range:" error:@"nil argument"];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return 0;
    }
    
    NSUInteger tmp = (searchRange.location + searchRange.length);
    if (tmp > self.length) {
        NSString *log = [self _formatLogWithSEL:@"replaceOccurrencesOfString:withString:options:range:" range:searchRange];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return 0;
    }
    
    return [self yh_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
}

- (void)yh_deleteCharactersInRange:(NSRange)range {
    NSUInteger tmp = (range.location + range.length);
    if (tmp > self.length) {
        NSString *log = [self _formatLogWithSEL:@"deleteCharactersInRange:" range:range];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return;
    }
    
    [self yh_deleteCharactersInRange:range];
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)yh_NSCFStringstringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    if (nil == target || nil == replacement) {
        NSString *log = [self _formatLogWithSEL:@"stringByReplacingOccurrencesOfString:withString:options:range:" error:@"nil argument"];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    NSUInteger tmp = (searchRange.location + searchRange.length);
    if (tmp > self.length) {
        NSString *log = [self _formatLogWithSEL:@"stringByReplacingOccurrencesOfString:withString:options:range:" range:searchRange];
        [YHAvoidUtils yh_reportErrorWithLog:log];
        return nil;
    }
    
    return [self yh_NSCFStringstringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
}

#pragma mark - Log
- (NSString *)_formatLogWithSEL:(NSString *)sel index:(NSUInteger)index {
    return [NSString stringWithFormat:@"- [%@ - %@]: Index %ld out of bounds; string length %ld", NSStringFromClass(self.class), sel, index, self.length];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel range:(NSRange)range {
    return [NSString stringWithFormat:@"- [%@ - %@]: Range {%ld, %ld} out of bounds; string length %ld", NSStringFromClass(self.class), sel, range.location, range.length, self.length];
}

- (NSString *)_formatLogWithSEL:(NSString *)sel error:(NSString *)error {
    return [NSString stringWithFormat:@"- [%@ - %@]: %@", NSStringFromClass(self.class), sel, error];
}

@end
