//
//  YHWeakProxy.h
//  来源于YYWeakProxy
//
//  Created by yanhoo on 21/03/08.
//  Copyright (c) 2021 yanhoo.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/**
 A proxy used to hold a weak object.
 It can be used to avoid retain cycles, such as the target in NSTimer or CADisplayLink.
 
 sample code:
 
     @implementation MyView {
        NSTimer *_timer;
     }
     
     - (void)initTimer {
        YHWeakProxy *proxy = [YHWeakProxy proxyWithTarget:self];
        _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
     }
     
     - (void)tick:(NSTimer *)timer {...}
     @end
 */
@interface YHWeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;
/**
 The proxy target name
 */
@property (nonatomic, copy, readonly) NSString *targetName;
/// 原target对应的方法实现
@property (nonatomic, assign) SEL oriSEL;
/// 回调方法是否有timer参数
@property (nonatomic, assign) BOOL oriSELHasParam;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

/// 代理对象的定时任务
/// @param timer 定时器
- (void)proxyTimerActionWithTimer:(NSTimer *)timer;

@end
