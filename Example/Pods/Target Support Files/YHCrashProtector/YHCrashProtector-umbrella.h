#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+AvoidCrash.h"
#import "NSMutableArray+AvoidCrash.h"
#import "NSDictionary+AvoidCrash.h"
#import "NSMutableDictionary+AvoidCrash.h"
#import "NSObject+BadAccessCrash.h"
#import "YHBadAccessManager.h"
#import "YHZoombie.h"
#import "NSObject+KVCCrash.h"
#import "NSObject+KVOCrash.h"
#import "YHKVOInfo.h"
#import "YHKVOProxy.h"
#import "NSNotificationCenter+AvoidCrash.h"
#import "NSObject+AvoidCrash.h"
#import "NSTimer+AvoidCrash.h"
#import "YHWeakProxy.h"
#import "NSAttributedString+AvoidCrash.h"
#import "NSMutableAttributedString+AvoidCrash.h"
#import "NSMutableString+AvoidCrash.h"
#import "NSString+AvoidCrash.h"
#import "NSObject+UnSELCrash.h"
#import "YHForwardingTarget.h"
#import "YHAvoidCrash.h"
#import "YHAvoidUtils.h"
#import "YHDeallocHandle.h"

FOUNDATION_EXPORT double YHCrashProtectorVersionNumber;
FOUNDATION_EXPORT const unsigned char YHCrashProtectorVersionString[];

