//
//  YHBadAccessManager.h
//  HBCAppCore
//
//  Created by 颜琥 on 2021/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHBadAccessManager : NSObject

+ (instancetype)sharedInstance;

- (void)handleDeallocObject:(id)object;

@end

NS_ASSUME_NONNULL_END
