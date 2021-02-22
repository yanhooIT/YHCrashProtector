//
//  YHPerson.m
//  YHCrashProtector_Example
//
//  Created by 颜琥 on 2021/2/1.
//  Copyright © 2021 yanhooit. All rights reserved.
//

#import "YHPerson.h"

@implementation YHPerson

+ (void)run {
    NSLog(@"run");
}

- (int)ages {
    return 30;
}

- (void)logPrint {
    NSLog(@"%s", __func__);
}

@end
