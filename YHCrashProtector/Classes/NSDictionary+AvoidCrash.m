//
//  NSDictionary+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSDictionary+AvoidCrash.h"
#import "AvoidUtils.h"

/**
 *
 *  1. NSDictionary的快速创建方式 NSDictionary *dict = @{@"frameWork" : @"AvoidCrash"};这种创建方式其实调用的是以下的方法：
 *
 *  + (instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
 *
 */

@implementation NSDictionary (AvoidCrash)

+ (void)avoidCrashExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AvoidUtils exchangeClassMethod:self oldMethod:@selector(dictionaryWithObjects:forKeys:count:) newMethod:@selector(avoidCrashDictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)avoidCrashDictionaryWithObjects:(const id *)objects forKeys:(const id<NSCopying> *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        NSString *defaultToDo = @"AvoidCrash default is to remove nil key-values and instance a dictionary.";
        [AvoidUtils noteErrorWithException:exception defaultToDo:defaultToDo];
        
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
