//
//  YHZoombie.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHZoombie.h"
#import <objc/runtime.h>
#import "YHForwardingTarget.h"

@implementation YHZoombie

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"[%@ %@] message sent to deallocated instance %@", objc_getAssociatedObject(self, "originClassName"), NSStringFromSelector(aSelector), self);
    
    return [YHForwardingTarget handleWithObject:self forwardingTargetForSelector:aSelector];
}

@end
