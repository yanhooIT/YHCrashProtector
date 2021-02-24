//
//  YHViewController.m
//  YHCrashProtector
//
//  Created by yanhooit on 02/01/2021.
//  Copyright (c) 2021 yanhooit. All rights reserved.
//

#import "YHViewController.h"
#import "YHPerson.h"
#import "YHBoy.h"
#import <objc/runtime.h>
#import "AvoidCrash.h"

@interface YHViewController ()

@property (nonatomic, assign) YHPerson *person1;
@property (nonatomic, assign) YHPerson *person2;
@property (nonatomic, assign) YHBoy *boy1;

@end

@implementation YHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testExcBadAccess];
}

- (void)testExcBadAccess {
    [AvoidCrash yh_setupHandleDeallocClassNames:@[@"YHPerson"]];
    
    self.person1 = [[YHPerson alloc] init];
    [self.person1 logPrint];
    
    self.person2 = [[YHPerson alloc] init];
    [self.person2 logPrint];

    self.boy1 = [[YHBoy alloc] init];
    [self.boy1 logPrint];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 测试：若在Zoombie实例达到上限，前面的Zoombie实例真正释放之后，再次调用野指针还是会出现Crash
    [self.person1 logPrint];
}

- (void)testUnrecognizedSelector {
    NSDictionary *dict2 = (NSDictionary *)[UIView new];
    NSString *str3 = dict2[@"key"];
    NSLog(@"%@", str3);
}

+ (void)crashTest {
    NSString *str = nil;
    
    // 1、数组越界检查
    // *** -[__NSArray0 objectAtIndex:]: index 1 beyond bounds for empty NSArray
    NSArray *arr = @[];
    NSString *str1 = arr[1];
    
    // 2、数组里设置nil
    // *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    // *** -[__NSSingleObjectArrayI objectAtIndex:]: index 1 beyond bounds [0 .. 0]
    NSArray *arr2 = @[@"111", str];
    NSString *str2 = arr2[1];
    
    // 3、给字典设置nil（两种方式）
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict = @{@"key1":str};
    // [<__NSDictionary0 0x1c401f360> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key key2.
    [dict setValue:str forKey:@"key2"];
}

/** 测试以下三个方法的作用
 class_respondsToSelector
 respondsToSelector
 instancesRespondToSelector
 */
- (void)testRespondsToSelector {
    YHPerson *p = [[YHPerson alloc] init];

    // ------ class_respondsToSelector从在当前传入的Class中查找方法 ------
    // [YHPerson class]是类对象，ages是实例方法，存储在类对象的方法列表中，所以为YES
    SEL sel1 = @selector(ages);
    SEL sel2 = @selector(run);
    BOOL yn1 = class_respondsToSelector([YHPerson class], sel1);// YES
    // object_getClass([YHPerson class])是元类对象，run是类方法，存储在元类对象的方法列表中，所以为YES
    BOOL yn2 = class_respondsToSelector(object_getClass([YHPerson class]), sel2); // YES
    
    // ------ （方法声明在 NSObject 协议中）respondsToSelector根据当前对象的isa所指的对象中查找方法 ------
    // [YHPerson class]的isa指向的是元类对象，ages是实例方法，存储在类对象的方法列表中，所以为NO
    BOOL yn3 = [[YHPerson class] respondsToSelector:sel1];// NO
    // [YHPerson class]的isa指向的是元类对象，run是类方法，存储在元类对象的方法列表中，所以为YES
    BOOL yn4 = [[YHPerson class] respondsToSelector:sel2]; // YES
    // p的isa指向的是类对象，ages是实例方法，存储在类对象的方法列表中，所以为YES
    BOOL yn5 = [p respondsToSelector:sel1];// YES
    // p的isa指向的是类对象，run是类方法，存储在元类对象的方法列表中，所以为NO
    BOOL yn6 = [p respondsToSelector:sel2]; // NO
    
    // ------ （方法声明在 NSObject 类中）instancesRespondToSelector类似class_respondsToSelector，这里不多做解释 ------
    BOOL yn7 = [[YHPerson class] instancesRespondToSelector:sel1];// YES
    BOOL yn8 = [object_getClass([YHPerson class]) instancesRespondToSelector:sel2]; // YES
    
    // 会查找父类中是否实现
    BOOL yn9 = class_respondsToSelector([YHBoy class], sel1);// YES
    BOOL yn10 = class_respondsToSelector(object_getClass([YHBoy class]), sel2); // YES
    
    NSLog(@"\nyn1 = %@\nyn2 = %@\nyn3 = %@\nyn4 = %@\nyn5 = %@\nyn6 = %@\nyn7 = %@\nyn8 = %@\nyn9 = %@\nyn10 = %@\n", yn1?@"YES":@"NO", yn2?@"YES":@"NO", yn3?@"YES":@"NO", yn4?@"YES":@"NO", yn5?@"YES":@"NO", yn6?@"YES":@"NO", yn7?@"YES":@"NO", yn8?@"YES":@"NO", yn9?@"YES":@"NO", yn10?@"YES":@"NO");
}

@end
