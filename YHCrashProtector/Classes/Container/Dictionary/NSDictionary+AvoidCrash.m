//
//  NSDictionary+AvoidCrash.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2020年 yanhoo. All rights reserved.
//

#import "NSDictionary+AvoidCrash.h"
#import "YHAvoidUtils.h"

@implementation NSDictionary (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YHAvoidUtils yh_exchangeClassMethod:self oldMethod:@selector(dictionaryWithObjects:forKeys:count:) newMethod:@selector(avoidCrashDictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)avoidCrashDictionaryWithObjects:(const id *)objects forKeys:(const id<NSCopying> *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to remove nil key-values and instance a dictionary.";
        [YHAvoidUtils yh_noteErrorWithException:exception defaultToDo:defaultToDo];
        
        // 处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id newObjects[cnt];
        id newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        
        instance = [self avoidCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

@end
