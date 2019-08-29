//
//  QSModelTests.m
//  QSModelTests
//
//  Created by apple on 2019/8/28.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface QSModelTests : XCTestCase

@end

@implementation QSModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - runtime 测试方法交换
- (void)testExample {
    
    Method methodA = class_getInstanceMethod([self class], @selector(printA));
    Method methodB = class_getInstanceMethod([self class], @selector(printB));
    method_exchangeImplementations(methodA, methodB);
    [self printA];
}

- (void)printA {
    NSLog(@"AAAAAA");
}

- (void)printB {
    NSLog(@"BBBBBB");
}

#pragma mark - runtime 添加属性
- (void)testProperty {
    
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
