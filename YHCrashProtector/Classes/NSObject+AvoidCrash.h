//
//  NSObject+AvoidCrash.h
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvoidCrashProtocol.h"

@interface NSObject (AvoidCrash) <AvoidCrashProtocol>

+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings;

+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs;

@end
