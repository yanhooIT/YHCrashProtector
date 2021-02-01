//
//  YHBadAccessManager.h
//  https://github.com/yanhooIT/YHCrashProtector
//
//  Created by yanhoo on 2020/02/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHBadAccessManager : NSObject

+ (instancetype)sharedInstance;

- (void)handleDeallocObject:(id)object;

@end

NS_ASSUME_NONNULL_END
