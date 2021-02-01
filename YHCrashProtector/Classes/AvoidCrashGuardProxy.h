//
//  AvoidCrashGuardProxy.h
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by chenfanfang on 2017/7/25.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface AvoidCrashGuardProxy : NSObject

/// 消息转发阶段交给代理对象处理
/// @param object 消息接收对象
/// @param aSelector 方法名
/// @return 能处理该消息的代理对象
+ (id)handleObject:(id)object forwardingTargetForSelector:(SEL)aSelector;

@end
