//
//  YHForwardingTarget.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//  Copyright © 2017年 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface YHForwardingTarget : NSObject

/// 消息转发阶段交给代理对象处理
/// @param object 消息接收对象
/// @param aSelector 方法名
/// @return 能处理该消息的代理对象
+ (id)handleWithObject:(id)object forwardingTargetForSelector:(SEL)aSelector;

@end
