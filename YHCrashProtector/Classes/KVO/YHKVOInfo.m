//
//  YHKVOInfo.m
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/3/2.
//

#import "YHKVOInfo.h"

@implementation YHKVOInfo

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath {
    if (self = [super init]) {
        _observer = observer;
        _keyPath = keyPath;
    }
    
    return self;
}

@end
