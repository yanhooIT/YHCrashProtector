//
//  YHZoombie.m
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import "YHZoombie.h"
#import <objc/runtime.h>
#import "YHForwardingTarget.h"
#import "YHAvoidUtils.h"

@implementation YHZoombie

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 上报错误信息
    NSString *log = [[NSString alloc] initWithFormat:@"\"%@\" message sent to a deallocated instance, the instance's class is \"%@\"", NSStringFromSelector(aSelector), objc_getAssociatedObject(self, "originClassName")];
    [YHAvoidLogger yh_reportError:log];
    
    return [YHForwardingTarget handleWithObject:self forwardingTargetForSelector:aSelector];
}

@end
