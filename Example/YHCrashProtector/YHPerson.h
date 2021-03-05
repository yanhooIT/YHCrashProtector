//
//  YHPerson.h
//  YHCrashProtector_Example
//
//  Created by 颜琥 on 2021/2/1.
//  Copyright © 2021 yanhooit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name2;

- (void)logPrint;

@end

NS_ASSUME_NONNULL_END
