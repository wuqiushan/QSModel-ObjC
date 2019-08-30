//
//  Student.h
//  QSModel
//
//  Created by wuqiushan on 2019/8/29.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Courses.h"
#import "NSObject+QSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property(nonatomic, copy) NSString * Id;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * age;
@property(nonatomic, assign) NSInteger weight;
@property(nonatomic, assign) BOOL six;

@property(nonatomic, strong) Address *address; // 对象
@property(nonatomic, strong) NSDictionary *addressA;

// <Courses *>
@property(nonatomic, strong) NSArray *courses;  // 元素是对象
@property(nonatomic, strong) NSArray *coursesA; // 元素为普通

@property(nonatomic, strong) NSDate *birthday; // 日期

@end

NS_ASSUME_NONNULL_END
