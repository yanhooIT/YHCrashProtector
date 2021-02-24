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
    NSLog(@"CrashProtector - \"%@\" message sent to a deallocated instance, the instance's class is \"%@\"", NSStringFromSelector(aSelector), objc_getAssociatedObject(self, "originClassName"));
    
    return [YHForwardingTarget handleWithObject:self forwardingTargetForSelector:aSelector];
}

@end
