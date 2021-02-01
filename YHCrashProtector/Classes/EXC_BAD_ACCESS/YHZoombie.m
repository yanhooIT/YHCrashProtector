//
//  YHZoombie.m
//  HBCAppCore
//
//  Created by 颜琥 on 2021/1/29.
//

#import "YHZoombie.h"
#import <objc/runtime.h>
#import "AvoidCrashGuardProxy.h"

@implementation YHZoombie

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"[%@ %@] message sent to deallocated instance %@", objc_getAssociatedObject(self, "originClassName"), NSStringFromSelector(aSelector), self);
    
    return [AvoidCrashGuardProxy new];
}

@end
