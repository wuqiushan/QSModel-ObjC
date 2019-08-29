//
//  ViewController.m
//  QSModel
//
//  Created by apple on 2019/8/28.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+iOS.h"
#import "Person.h"
#import "objc/runtime.h"
#import "NSObject+QSModel.h"
#import "Student.h"

@interface ViewController ()

@property(nonatomic, strong) Person *person;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [[Person alloc] init];
//    [self testProperty];
//    [self testClassProperty];
//    [self testClassIvar];
//    [self testClassMethod];
//    [self testClassProtocol];
    
//    [self testChangeProperty];
    [self testQSModel];
}


#pragma mark - runtime 分类添加属性
- (void)testProperty {
    UIImage *image = [[UIImage alloc] init];
    image.url = @"www.baidu.com";
    NSLog(@"分类属性： %@", image.url);
}

#pragma mark - runtime 获取类属性列表
- (void)testClassProperty {
    
    unsigned int count;
    objc_property_t *properyList = class_copyPropertyList([self.person class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        const char *propertyName = property_getName(properyList[i]);
        NSLog(@"Property --- %d --- %@", i, [NSString stringWithUTF8String:propertyName]);
    }
    free(properyList);
}

#pragma mark - runtime 获取成员变量
- (void)testClassIvar {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self.person class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSLog(@"ivar --- %d --- %@", i, [NSString stringWithUTF8String:ivarName]);
    }
    free(ivarList);
}

#pragma mark - runtime 获取所有方法
- (void)testClassMethod {
    unsigned int count;
    Method *methodList = class_copyMethodList([self.person class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        NSLog(@"method --- %d --- %@", i, NSStringFromSelector(methodName));
    }
    free(methodList);
}

#pragma mark - runtime 获取协议
- (void)testClassProtocol {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self.person class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Protocol *protocal = protocolList[i];
        const char *protocolName = protocol_getName(protocal);
        NSLog(@"protocol(%d): %@",i, [NSString stringWithUTF8String:protocolName]);
    }
    free(protocolList);
}

#pragma mark - runtime 动态改变私有属性
- (void)testChangeProperty {
    
    NSLog(@"nickName 改变前为 %@", [self.person valueForKey:@"nickName"]);
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self.person class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *propertyName = [NSString stringWithUTF8String:ivarName];
        if ([propertyName isEqualToString:@"_nickName"]) {
            object_setIvar(self.person, ivar, @"张三");
        }
    }
    NSLog(@"nickName 改变后为 %@", [self.person valueForKey:@"nickName"]);
    free(ivarList);
}

#pragma mark -- runtime 字典转模型
- (void)testQSModel {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Student" ofType:@"json"];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
    NSLog(@"转换前 json文件：\n %@", jsonDic);
    
    NSObject *object = [Student modelWithDic:jsonDic];
    NSDictionary *resultDic = [object dicWithObject];
    NSLog(@"转换后 json文件：\n %@", resultDic);
}

@end
