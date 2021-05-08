//
//  NSDictionary+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSDictionary+AvoidCrash.h"
#import "YHAvoidUtils.h"

/** Dictionary类簇
 // ------ NSDictionary ------
 // __NSPlaceholderDictionary
 NSLog(@"[NSDictionary alloc].class: %@", [NSDictionary alloc].class);
 // __NSDictionary0
 NSLog(@"[[NSDictionary alloc] init].class: %@", [[NSDictionary alloc] init].class);
 // __NSDictionary0
 NSLog(@"[@{} class]: %@", [@{} class]);
 // __NSSingleEntryDictionaryI
 NSLog(@"[@{@1:@1} class]: %@", [@{@1:@1} class]);
 // __NSDictionaryI
 NSLog(@"[@{@1:@1, @2:@2} class]: %@", [@{@1:@1, @2:@2} class]);

 // ------ NSMutableDictionary ------
 // __NSPlaceholderDictionary
 NSLog(@"[NSMutableDictionary alloc].class: %@", [NSMutableDictionary alloc].class);
 // __NSDictionaryM
 NSLog(@"[[NSMutableDictionary alloc] init].class: %@", [[NSMutableDictionary alloc] init].class);
 // __NSDictionaryM
 NSLog(@"[@{}.mutableCopy class]: %@", [@{}.mutableCopy class]);
 // __NSDictionaryM
 NSLog(@"[@{@1:@1}.mutableCopy class]: %@", [@{@1:@1}.mutableCopy class]);
 // __NSDictionaryM
 NSLog(@"[@{@1:@1, @2:@2}.mutableCopy class]: %@", [@{@1:@1, @2:@2}.mutableCopy class]);
 */

@implementation NSDictionary (AvoidCrash)

+ (void)yh_enabledAvoidDictionaryCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSPlaceholderDictionary = NSClassFromString(@"__NSPlaceholderDictionary");
        // initWithObjects:forKeys:count:
        // dictionaryWithObjects:forKeys:count:无需hook，最终都会走initWithObjects:forKeys:count:
        [YHAvoidUtils yh_swizzleInstanceMethod:__NSPlaceholderDictionary oldMethod:@selector(initWithObjects:forKeys:count:) newMethod:@selector(yh_initWithObjects:forKeys:count:)];
    });
}

- (instancetype)yh_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        // 处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id newObjects[cnt];
        id newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            id obj = objects[i];
            id key = keys[i];
            
            if (nil == obj) {
                NSString *log = [[NSString alloc] initWithFormat:@"[%@ - initWithObjects:forKeys:count:]: object is nil", NSStringFromClass(self.class)];
                [YHAvoidLogger yh_reportError:log];
                continue;
            }
            
            if (nil == key) {
                NSString *log = [[NSString alloc] initWithFormat:@"[%@ - initWithObjects:forKeys:count:]: key is nil", NSStringFromClass(self.class)];
                [YHAvoidLogger yh_reportError:log];
                continue;
            }

            newObjects[index] = objects[i];
            newkeys[index] = keys[i];
            index++;
        }
            
        instance = [self yh_initWithObjects:newObjects forKeys:newkeys count:index];
    } @catch (NSException *exception) {
        [YHAvoidLogger yh_reportException:exception];
    } @finally {
        return instance;
    }
}

@end
