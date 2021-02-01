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

@interface YHViewController ()

@end

@implementation YHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self testUnrecognizedSelector];
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

    // 4、unrecognized selector sent to instance for dict
    // -[NSNull objectForKeyedSubscript:]: unrecognized selector sent to instance
    NSDictionary *dict2 = (NSDictionary *)[NSNull null];
    NSString *str3 = dict2[@"key"];
    
    // 5、unrecognized selector sent to instance for array
    // -[NSNull objectAtIndexedSubscript:]: unrecognized selector sent to instance
    NSArray *arr3 = (NSArray *)[NSNull null];
    NSString *str4 = arr3[1];
    
    // crashTest: str1:(null)--str2:(null)--str3:(null)--str4:(null)
    NSLog(@"crashTest: str1:%@--str2:%@--str3:%@--str4:%@", str1, str2, str3, str4);
}

- (void)test {
    YHPerson *p = [[YHPerson alloc] init];

    // ------ class_respondsToSelector从在当前传入的Class中查找方法 ------
    // [YHPerson class]是类对象，ages是实例方法，存储在类对象的方法列表中，所以为YES
    BOOL yn1 = class_respondsToSelector([YHPerson class], @selector(ages));// YES
    // object_getClass([YHPerson class])是元类对象，run是类方法，存储在元类对象的方法列表中，所以为YES
    BOOL yn2 = class_respondsToSelector(object_getClass([YHPerson class]), @selector(run)); // YES
    
    // ------ （方法声明在 NSObject 协议中）respondsToSelector根据当前对象的isa所指的对象中查找方法 ------
    // [YHPerson class]的isa指向的是元类对象，ages是实例方法，存储在类对象的方法列表中，所以为NO
    BOOL yn3 = [[YHPerson class] respondsToSelector:@selector(ages)];// NO
    // [YHPerson class]的isa指向的是元类对象，run是类方法，存储在元类对象的方法列表中，所以为YES
    BOOL yn4 = [[YHPerson class] respondsToSelector:@selector(run)]; // YES
    // p的isa指向的是类对象，ages是实例方法，存储在类对象的方法列表中，所以为YES
    BOOL yn5 = [p respondsToSelector:@selector(ages)];// YES
    // p的isa指向的是类对象，run是类方法，存储在元类对象的方法列表中，所以为NO
    BOOL yn6 = [p respondsToSelector:@selector(run)]; // NO
    
    // ------ （方法声明在 NSObject 类中）instancesRespondToSelector类似class_respondsToSelector，这里不多做解释 ------
    BOOL yn7 = [[YHPerson class] instancesRespondToSelector:@selector(ages)];// YES
    BOOL yn8 = [object_getClass([YHPerson class]) instancesRespondToSelector:@selector(run)]; // YES
    
    // 会查找父类中是否实现
    BOOL yn9 = class_respondsToSelector([YHBoy class], @selector(ages));// YES
    BOOL yn10 = class_respondsToSelector(object_getClass([YHBoy class]), @selector(run)); // YES
    
    NSLog(@"\nyn1 = %@\nyn2 = %@\nyn3 = %@\nyn4 = %@\nyn5 = %@\nyn6 = %@\nyn7 = %@\nyn8 = %@\nyn9 = %@\nyn10 = %@\n", yn1?@"YES":@"NO", yn2?@"YES":@"NO", yn3?@"YES":@"NO", yn4?@"YES":@"NO", yn5?@"YES":@"NO", yn6?@"YES":@"NO", yn7?@"YES":@"NO", yn8?@"YES":@"NO", yn9?@"YES":@"NO", yn10?@"YES":@"NO");
}

@end
