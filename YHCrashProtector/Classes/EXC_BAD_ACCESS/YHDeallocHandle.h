//
//  YHDeallocHandle.h
//  YHCrashProtector
//
//  Created by 颜琥 on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDeallocHandle : NSObject

/// 模拟Xcode的 Zoombie Objects 僵尸对象调试原理
/// @param obj 要处理的对象
+ (void)handleDeallocObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
