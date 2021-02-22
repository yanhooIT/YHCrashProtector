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

#import "AvoidCrash.h"
#import "AvoidUtils.h"
#import "NSArray+AvoidCrash.h"
#import "NSDictionary+AvoidCrash.h"
#import "NSMutableArray+AvoidCrash.h"
#import "NSMutableDictionary+AvoidCrash.h"
#import "YHBadAccessManager.h"
#import "YHZoombie.h"
#import "NSObject+AvoidCrash.h"
#import "NSAttributedString+AvoidCrash.h"
#import "NSMutableAttributedString+AvoidCrash.h"
#import "NSMutableString+AvoidCrash.h"
#import "NSString+AvoidCrash.h"
#import "YHForwardingTarget.h"
#import "YHAvoidCrashProtocol.h"
#import "YHDeallocHandle.h"

FOUNDATION_EXPORT double YHCrashProtectorVersionNumber;
FOUNDATION_EXPORT const unsigned char YHCrashProtectorVersionString[];

