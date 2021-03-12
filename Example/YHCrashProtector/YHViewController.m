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
#import "YHAvoidCrash.h"

@interface YHViewController ()

@property (nonatomic, strong) YHPerson *person;

@property (nonatomic, assign) YHPerson *person1;
@property (nonatomic, assign) YHPerson *person2;
@property (nonatomic, assign) YHBoy *boy1;

@end

@implementation YHViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self testKVOCrashRemove];
    
//    [self triggerExcBadAccess];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self testAttributedStringCrash];
//    [self testAttributedStringMCrash];
//
//    [self testStringCrash];
//    [self testStringMCrash];
//
//    [self testDictionaryCrash];
//    [self testDictionaryMCrash];
//
//    [self testArrayCrash];
//    [self testArrayMCrash];
//
//    [self testTimerCrash];
//
//    [self testKVCCrash];
//
//    [self testKVOCrash];
//
//    [self testExcBadAccess];
//
//    [self testUnrecognizedSelector];
    
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark - NSAttributedString Crash Test
- (void)testAttributedStringCrash {
    NSString *nilStr = nil;
    
    // NSConcreteAttributedString initWithString:: nil value
    [[NSAttributedString alloc] initWithString:nilStr];
    
    // NSConcreteAttributedString initWithString:: nil value
    [[NSAttributedString alloc] initWithAttributedString:nilStr];
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor redColor] };
    // NSConcreteAttributedString initWithString:: nil value
    [[NSAttributedString alloc] initWithString:nilStr attributes:attributes];
}

- (void)testAttributedStringMCrash {
    NSString *nilStr = nil;
    
    // NSConcreteMutableAttributedString initWithString:: nil value
    [[NSMutableAttributedString alloc] initWithString:nilStr];

    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor redColor] };
    // NSConcreteMutableAttributedString initWithString:attributes:: nil value
    [[NSMutableAttributedString alloc] initWithString:nilStr attributes:attributes];
}

#pragma mark - NSString Crash Test
- (void)testStringCrash {
    NSString *str = @"123";
    
    // -[NSPlaceholderString initWithString:]: nil argument
    [[NSString alloc] initWithString:nil];

    // -[__NSCFConstantString hasPrefix:]: nil argument
    [str hasPrefix:nil];

    // -[__NSCFConstantString hasSuffix:]: nil argument
    [str hasSuffix:nil];

    // -[__NSCFConstantString characterAtIndex:]: Range or index out of bounds
    unichar characteristic = [str characterAtIndex:3];

    // -[__NSCFConstantString substringFromIndex:]: Index 10 out of bounds; string length 3
    [str substringFromIndex:4];
    
    // -[__NSCFConstantString substringToIndex:]: Index 10 out of bounds; string length 3
    [str substringToIndex:4];
    
    // -[__NSCFConstantString substringWithRange:]: Range {0, 10} out of bounds; string length 3
    NSRange range1 = NSMakeRange(0, 10);
    [str substringWithRange:range1];
    
    // -[__NSCFConstantString stringByReplacingOccurrencesOfString:withString:options:range:]: nil argument
    NSString *nilStr = nil;
    [str stringByReplacingOccurrencesOfString:@"" withString:nilStr];
    [str stringByReplacingOccurrencesOfString:nilStr withString:@""];
}

- (void)testStringMCrash {
    NSMutableString *strM = @"123".mutableCopy;
    
    // -[__NSCFString insertString:atIndex:]: nil argument
    [strM insertString:nil atIndex:1];
    // -[__NSCFString insertString:atIndex:]: Range or index out of bounds
    [strM insertString:@"cool" atIndex:4];
    
    // -[__NSCFString deleteCharactersInRange:]: Range or index out of bounds
    NSRange range2 = NSMakeRange(0, 10);
    [strM deleteCharactersInRange:range2];
    
    // -[__NSCFString replaceOccurrencesOfString:withString:options:range:]: Range {0, 10} out of bounds; string length 3
    NSRange range3 = NSMakeRange(0, 10);
    NSString *nilStr = nil;
    [strM stringByReplacingOccurrencesOfString:nilStr withString:@"" options:NSCaseInsensitiveSearch range:range3];
    // -[__NSCFString stringByReplacingOccurrencesOfString:withString:options:range:]: nil argument
    [strM stringByReplacingOccurrencesOfString:@"8" withString:nilStr options:NSCaseInsensitiveSearch range:range3];
    [strM stringByReplacingOccurrencesOfString:@"8" withString:@"" options:NSCaseInsensitiveSearch range:range3];
    
    // -[__NSCFString replaceCharactersInRange:withString:]: Range or index out of bounds
    NSRange range4 = NSMakeRange(0, 10);
    [strM stringByReplacingCharactersInRange:range4 withString:@"cff"];
    
    // -[__NSCFString replaceCharactersInRange:withString:]: Range or index out of bounds
    NSRange range1 = NSMakeRange(0, 10);
    [strM replaceCharactersInRange:range1 withString:@"-"];
}

#pragma mark - Container Crash Test
- (void)testDictionaryCrash {
    NSString *str = nil;
    
    // value为nil
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict1 = @{@"key1":str};
    
    // key为nil
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict2 = @{str:@"123"};
    
    // value为nil
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict3 = [NSDictionary dictionaryWithObject:str forKey:@"key"];
    
    // key为nil
    // *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]
    NSDictionary *dict4 = [NSDictionary dictionaryWithObject:@"123" forKey:str];
}

- (void)testDictionaryMCrash {
    NSString *str = nil;
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    // *** -[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil
    dict1[str] = @"123";
    
    // 这种不会Crash
    dict1[@"key"] = str;
    [dict1 setObject:str forKeyedSubscript:@"key"];
    [dict1 removeObjectForKey:@"key"];
    
    // *** -[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: key)
    [dict1 setObject:str forKey:@"key"];

    // =*** -[__NSDictionaryM setObject:forKey:]: key cannot be nil
    [dict1 setObject:@"123" forKey:str];

    // *** -[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil
    [dict1 setObject:@"123" forKeyedSubscript:str];

    // *** -[__NSDictionaryM removeObjectForKey:]: key cannot be nil
    [dict1 removeObjectForKey:str];
}

- (void)testArrayCrash {
    NSString *str = nil;

    // *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    NSArray *arr1 = @[@"111", str];

    // *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[2]
    NSString *strings[3];
    strings[0] = @"111";
    strings[1] = @"222";
    strings[2] = nil;
    NSArray *arr2 = [NSArray arrayWithObjects:strings count:4];

    // 这种不会发生Crash
    NSArray *arr3 = [NSArray arrayWithObjects:@"111", str, nil];
    
    // 数组越界检查
    // *** -[__NSArray0 objectAtIndex:]: index 0 beyond bounds for empty NSArray
    NSArray *arr4 = @[];
    arr4[0];

    // *** -[__NSSingleObjectArrayI objectAtIndex:]: index 1 beyond bounds [0 .. 0]
    NSArray *arr5 = @[@"1"];
    arr5[1];
    
    // *** -[__NSArrayI objectAtIndexedSubscript:]: index 2 beyond bounds [0 .. 1]
    NSArray *arr6 = @[@"1", @"2"];
    arr6[2];
}

- (void)testArrayMCrash {
    NSString *str = nil;

    // *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    @[@"111", str].mutableCopy;
    
    // *** -[__NSArrayM objectAtIndexedSubscript:]: index 1 beyond bounds for empty array
    NSMutableArray *arr1 = [NSMutableArray array];
    arr1[0];
    
    // *** -[__NSArrayM objectAtIndexedSubscript:]: index 1 beyond bounds [0 .. 0]
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObject:@"1"];
    arr2[1];
    
    // *** -[__NSArrayM objectAtIndexedSubscript:]: index 2 beyond bounds [0 .. 1]
    NSMutableArray *arr3 = [NSMutableArray array];
    [arr3 addObject:@"1"];
    [arr3 addObject:@"2"];
    arr3[2];
    
    NSMutableArray *arr4 = [NSMutableArray array];
    // *** -[__NSArrayM insertObject:atIndex:]: object cannot be nil
    [arr4 addObject:str];
    
    // *** -[__NSArrayM insertObject:atIndex:]: object cannot be nil
    [arr4 insertObject:nil atIndex:1];
    
    // *** -[__NSArrayM insertObject:atIndex:]: index 1 beyond bounds for empty array
    [arr4 insertObject:@"123" atIndex:1];
    
    // *** -[__NSArrayM replaceObjectAtIndex:withObject:]: index 0 beyond bounds for empty array
    [arr4 replaceObjectAtIndex:0 withObject:@"111"];
    
    // *** -[__NSArrayM removeObjectsInRange:]: range {0, 1} extends beyond bounds for empty array
    [arr4 removeObjectAtIndex:0];
    
    // *** -[__NSArrayM setObject:atIndexedSubscript:]: index 5 beyond bounds for empty array
    arr4[5] = @"";
}

- (void)printContainerType {
    // NSArray
    NSLog(@"[NSArray alloc].class: %@", [NSArray alloc].class); // __NSPlaceholderArray
    NSLog(@"[[NSArray alloc] init].class: %@", [[NSArray alloc] init].class); // __NSArray0
    NSLog(@"@[].class: %@", @[].class); // __NSArray0
    NSLog(@"@[@1].class: %@", @[@1].class); // __NSSingleObjectArrayI
    NSLog(@"@[@1, @2].class: %@", @[@1, @2].class); // __NSArrayI
        
    // NSMutableArray
    NSLog(@"[NSMutableArray alloc].class: %@", [NSMutableArray alloc].class); // __NSPlaceholderArray
    NSLog(@"[[NSMutableArray alloc] init].class: %@", [[NSMutableArray alloc] init].class); // __NSArrayM
    NSLog(@"[@[].mutableCopy class]: %@", [@[].mutableCopy class]); // __NSArrayM
    NSLog(@"[@[@1].mutableCopy class]: %@", [@[@1].mutableCopy class]); // __NSArrayM
    NSLog(@"[@[@1, @2].mutableCopy class]: %@", [@[@1, @2].mutableCopy class]); // __NSArrayM

    // ------ NSDictionary ------
    // __NSPlaceholderDictionary
    NSLog(@"[NSDictionary alloc].class: %@", [NSDictionary alloc].class);
    // __NSDictionary0
    NSLog(@"[[NSDictionary alloc] init].class: %@", [[NSDictionary alloc] init].class);
    // __NSDictionary0
    NSLog(@"[@{} class]: %@", [@{} class]);
    // __NSSingleEntryDictionaryI
    NSLog(@"[@{@1:@1} class]: %@", [@{@1:@1} class]);
    // __NSDictionaryI
    NSLog(@"[@{@1:@1, @2:@2} class]: %@", [@{@1:@1, @2:@2} class]);

    // ------ NSMutableDictionary ------
    // __NSPlaceholderDictionary
    NSLog(@"[NSMutableDictionary alloc].class: %@", [NSMutableDictionary alloc].class);
    // __NSDictionaryM
    NSLog(@"[[NSMutableDictionary alloc] init].class: %@", [[NSMutableDictionary alloc] init].class);
    // __NSDictionaryM
    NSLog(@"[@{}.mutableCopy class]: %@", [@{}.mutableCopy class]);
    // __NSDictionaryM
    NSLog(@"[@{@1:@1}.mutableCopy class]: %@", [@{@1:@1}.mutableCopy class]);
    // __NSDictionaryM
    NSLog(@"[@{@1:@1, @2:@2}.mutableCopy class]: %@", [@{@1:@1, @2:@2}.mutableCopy class]);

    // __NSCFNumber
    NSLog(@"num:%@", [@1 class]);
}

#pragma mark - Timer Crash Test
- (void)testTimerCrash {
    
}

#pragma mark - KVC Crash Test
- (void)testKVCCrash {
    // (1)设置值时找不到对应的key
    /** 崩溃日志
     
     [<YHPerson 0x60000363d840> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key: xxx, value:xxx市xxx区.
     */
//    YHPerson *objc1 = [[YHPerson alloc] init];
//    [objc1 setValue:@"xxx市xxx区" forKey:@"xxx"];
    
    // (2)设置值时找不到对应的keyPath
    /** 崩溃日志
     
     [<YHPerson 0x600000648540> valueForUndefinedKey:]: this class is not key value coding-compliant for the key: xxx.
     [<YHPerson 0x600000648540> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key: yyy, value:xxx路xxx号.
     */
//    YHPerson *objc2 = [[YHPerson alloc] init];
//    [objc2 setValue:@"xxx路xxx号" forKeyPath:@"xxx.yyy"];

    // (3)key为nil会崩溃（如果传 nil 会提示警告，传空变量则不会提示警告）
    /** 崩溃日志
     
     [<YHPerson 0x600003637c20> setValue:forKey:]: attempt to set a value for a nil key, value:xxx.
     */
//    NSString *keyName = nil;
//    YHPerson *objc3 = [[YHPerson alloc] init];
//    [objc3 setValue:@"xxx" forKey:keyName];

    // (4)value 为 nil 会崩溃
    /** 崩溃日志
     
     [<YHPerson 0x60000362d400> setNilValueForKey]: could not set nil as the value for the key age.
     */
    YHPerson *objc4 = [[YHPerson alloc] init];
    // NSNumber
    [objc4 setValue:nil forKey:@"age"];
    // NSValue
    [objc4 setValue:nil forKey:@"point"];
    
    // (5)找不到对应的key
    /** 崩溃日志
     
     [<YHPerson 0x600003637c00> valueForUndefinedKey:]: this class is not key value coding-compliant for the key: xxx.
     */
//    YHPerson *objc5 = [[YHPerson alloc] init];
//    [objc5 valueForKey:@"xxx"];
}

#pragma mark - KVO Crash Test
- (void)testKVOCrash {
    self.person = [[YHPerson alloc] init];
    // 多次添加不会导致Crash，但是会产生多个监听，所以移除时记得要移除对应的次数
    /**
     self.person是被观察对象
     self是观察对象
     */
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
//    // 测试对象销毁后移除kvo所有观察对象
//    YHPerson *person = [[YHPerson alloc] init];
//    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [person addObserver:self forKeyPath:@"name2" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)testKVOCrashRemove {
    // 因为添加了两次监听，这里只移除了一次，还有一个监听
    [self.person removeObserver:self forKeyPath:@"name"];
    self.person.name = @"AAA";
    
    // 移除次数与添加次数要一一对应，因为添加了两次监听，这里移除了三次，超过添加次数就会导致Crash了
//    [self.person removeObserver:self.person forKeyPath:@"name"];
//    [self.person removeObserver:self.person forKeyPath:@"name"];
//    [self.person removeObserver:self.person forKeyPath:@"name"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath: %@, object: %@", keyPath, object);
}

#pragma mark - EXC_BAD_ACCESS Crash Test
- (void)testExcBadAccess {
    [YHAvoidCrash yh_setupHandleDeallocClassNames:@[@"YHPerson"]];
    
    self.person1 = [[YHPerson alloc] init];
    [self.person1 logPrint];
    
    self.person2 = [[YHPerson alloc] init];
    [self.person2 logPrint];

    self.boy1 = [[YHBoy alloc] init];
    [self.boy1 logPrint];
}

- (void)triggerExcBadAccess {
    /** 测试EXC_BAD_ACCESS Crash时使用
     测试：若在Zoombie实例达到上限，前面的Zoombie实例真正释放之后，再次调用野指针还是会出现Crash
     */
    [self.person1 logPrint];
}

#pragma mark - UnrecognizedSelector Crash Test
- (void)testUnrecognizedSelector {
    NSDictionary *dict2 = (NSDictionary *)[UIView new];
    NSString *str3 = dict2[@"key"];
    NSLog(@"%@", str3);
}

#pragma mark - respondsToSelector
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
    
    // ------ （方法声明在 NSObject 协议中）respondsToSelector根据当前对象的isa指针所指向的对象中查找方法 ------
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
