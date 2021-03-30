//
//  UINavigationController+AvoidCrash.m
//  YHAvoidCrash
//
//  Created by 颜琥 on 2021/3/26.
//

#import "UINavigationController+AvoidCrash.h"
#import <objc/runtime.h>
#import "YHAvoidUtils.h"

@interface UINavigationController ()

/// 转场动画是否进行中，如果进行中就不要重复执行（不指定默认赋值修饰符为assign）
@property (nonatomic, getter = isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@implementation UINavigationController (AvoidCrash)

+ (void)yh_enabledAvoidNoAddSelfAsSubviewCrash {
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(pushViewController:animated:) newMethod:@selector(yh_pushViewController:animated:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(didShowViewController:animated:) newMethod:@selector(yh_didShowViewController:animated:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(popViewControllerAnimated:) newMethod:@selector(yh_popViewControllerAnimated:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(popToViewController:animated:) newMethod:@selector(yh_popToViewController:animated:)];
    [YHAvoidUtils yh_swizzleInstanceMethod:[self class] oldMethod:@selector(popToRootViewControllerAnimated:) newMethod:@selector(yh_popToRootViewControllerAnimated:)];
}

- (void)yh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.delegate = self;
    
    // If we are already pushing a view controller, we dont push another one.
    if (!self.isViewTransitionInProgress) {
        if (animated) {
            self.viewTransitionInProgress = YES;
        }
        
        [self yh_pushViewController:viewController animated:animated];
    }
}

- (void)yh_didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self yh_didShowViewController:viewController animated:animated];
    self.viewTransitionInProgress = NO;
}

- (UIViewController *)yh_popViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    
    return [self yh_popViewControllerAnimated:animated];
}

- (NSArray *)yh_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    
    return [self yh_popToViewController:viewController animated:animated];
}

- (NSArray *)yh_popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    
    return [self yh_popToRootViewControllerAnimated:animated];
}

// If the user does not complete the swipe-to-go-back gesture, we need to intercept it and set the flag to NO again.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.viewTransitionInProgress = NO;
        
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)viewController;
        [self.interactivePopGestureRecognizer setEnabled:YES];
    }];
    
    if (navigationController.delegate != self) {
        [navigationController.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

#pragma mark - Getters and Setters
- (void)setViewTransitionInProgress:(BOOL)isInProgress {
    NSNumber *number = [NSNumber numberWithBool:isInProgress];
    objc_setAssociatedObject(self, @selector(isViewTransitionInProgress), number, OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)isViewTransitionInProgress {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number boolValue];
}

@end
