//
//  Student.m
//  QSModel
//
//  Created by wuqiushan on 2019/8/29.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import "Student.h"

@implementation Student

+ (NSDictionary *)QSMapping {
    return @{
             @"Id": @"id",
             @"courses": [Courses class],
             @"birthday": @"yyyy-MM-dd HH:mm:ss.SSS"
             };
}

@end
