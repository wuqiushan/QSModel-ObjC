//
//  NSObject+QSModel.m
//  QSModel
//
//  Created by wuqiushan on 2019/8/29.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import "NSObject+QSModel.h"
#import "objc/runtime.h"

@implementation NSObject (QSModel)


#pragma mark - 字典 >>> 模型
+ (instancetype)modelWithDic:(NSDictionary *)dic {
    
    if (!dic) { return nil; }
    NSObject *object = [[self alloc] init];
    
    // 通过runtime获取模型里的所有成员变量
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([object class], &count);
    
    // 自定义映射的代理里(注意这里，因为有递归的存在，所以这里只第一次拿)
    NSDictionary *mapDic = nil;
    if ([self respondsToSelector:@selector(QSMapping)]) {
        mapDic = [self performSelector:@selector(QSMapping)];
    }
    
    // 遍历所有成员变量
    for (unsigned int i = 0; i < count; i ++) {
        
        Ivar ivar = ivarList[i];
        // 获取成员变量
        const char *ivarChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarChar];
        ivarName = [ivarName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        // 获取成员变量类型
        const char *ivarTypeChar = ivar_getTypeEncoding(ivar);
        NSString *ivarType = [NSString stringWithUTF8String:ivarTypeChar];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        // 通过成员变量拿到字典中的值
        id ivarValue = dic[ivarName];
        id mapValue = nil;  // 存自定义的值 例：@{@“id”: @"tid"} 存@"tid"用
        
        // ==> 拿字典值之前，先按自定义映射字段处理，也意味着优先级高
        if (mapDic && [mapDic.allKeys containsObject:ivarName]) {
            mapValue = [mapDic objectForKey:ivarName]; // 获取映射的值，即目标值的key
            if (mapValue && [mapValue isKindOfClass:[NSString class]]) {
                ivarValue = dic[mapValue];
            }
        }
        
        // 判断成员类型，针对不同的类型做不同的处理
        NSLog(@"%@ --- %@", ivarName, ivarType);
        
        // ==> 属性类型为对象(非NSDic) && 值为字典
        if (ivarValue && [ivarValue isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            
            NSLog(@"字典%@", ivarType);
            if ([ivarValue isKindOfClass:[NSDictionary class]]) {
                Class subClass = NSClassFromString(ivarType);
                if (subClass) {
                    ivarValue = [subClass modelWithDic:ivarValue];
                }
            }
        }
        
        // ==> 属性类型为NSArray(元素为对象) && 值为数组(元素为字典)
        else if (ivarValue && [ivarValue isKindOfClass:[NSArray class]] &&
                 ([ivarType isEqualToString:@"NSArray"] ||
                  [ivarType isEqualToString:@"NSMutableArray"]))
        {
            // 自定义处理的话 class类型
            if (mapValue && [mapValue isKindOfClass:[NSObject class]]) {
                
                // 获取class名称，把获取的对象元素存起来
                NSString *className = NSStringFromClass(mapValue);
                NSMutableArray *subObjectList = [[NSMutableArray alloc] init];
                
                for (id element in ivarValue) {
                    if (element && [element isKindOfClass:[NSDictionary class]]) {
                        Class subClass = NSClassFromString(className);
                        if (subClass) {
                            [subObjectList addObject:[subClass modelWithDic:element]];
                        }
                    }
                }
                ivarValue = subObjectList;
            }
            NSLog(@"数组%@", ivarType);
        }
        
        // ==> 属性类型为NSDate
        else if ([ivarType isEqualToString:@"NSDate"]) {
            
            // 如果有映射过且mapValue为字符串时，此值被改，现改回来
            ivarValue = dic[ivarName];
            if (mapValue && ivarValue) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:mapValue];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
                ivarValue = [formatter dateFromString:ivarValue];
            }
            
            NSLog(@"日期 %@", ivarType);
        }
        
        // ==> 默认不需要处理的属性类型：基本类型、NSNumber、NSInteger、NSDictionary(包含可变)、NSArray(包含可变)
        
        // 通过runtime把值赋给成员变量
        //object_setIvar(object, ivar, ivarValue); // 这种方式设置数据，值类型不要用这种方法
        // 通过KVC方式给成员赋值s
        if (ivarValue) {
            [object setValue:ivarValue forKey:ivarName];
        }
    }
    free(ivarList);
    return object;
}

#pragma mark - 模型 >>> 字典
- (NSDictionary *)dicWithObject {
    
    if (!self) { return nil; }
    
    // 用于存取当前转换后的值
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    
    // 遍历属性
    for (unsigned int i = 0; i < count; i ++) {
        
        Ivar ivar = ivarList[i];
        
        // 获取属性名
        const char *ivarChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarChar];
        ivarName = [ivarName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        // 获取属性类型
        const char *ivarTypeChar = ivar_getTypeEncoding(ivar);
        NSString *ivarType = [NSString stringWithUTF8String:ivarTypeChar];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        // 获取属性值，如果是值类型的，这种方式获取会闪退，原因是这种方式官方不允许获取值类型
//        id ivarValue = object_getIvar(self, ivar);
        id ivarValue = [self valueForKey:ivarName];
        
        // ==> 判断为数组中元素是对象
        
        if ([ivarType isEqualToString:@"NSArray"] || [ivarType isEqualToString:@"NSMutableArray"]) {
            
            // 把传化后的元素存起来
            NSMutableArray *subObjectList = [[NSMutableArray alloc] init];
            NSArray *arrayValue = (NSArray *)ivarValue;
            
            // 取第一个元素看一下是什么类型，主要判断是否为对象, 非对象时直接赋值
            if (arrayValue.count > 0) {
                id firstObject = [arrayValue firstObject];
                NSString *elementType = NSStringFromClass([firstObject class]);
                elementType = [elementType stringByReplacingOccurrencesOfString:@"_" withString:@""];
                if (![elementType hasPrefix:@"NS"] && [firstObject isKindOfClass:[NSObject class]]) {
                    
                    //如果是对象的话，就遍历
                    for (id element in ivarValue) {
                        [subObjectList addObject:[element dicWithObject]];
                    }
                    ivarValue = subObjectList;
                }
            }
        }
        
        // ==> 是对象 不含有“NS” && 继承NSObject(即：不是值类型)
        Class subClass = NSClassFromString(ivarType);
        if (![ivarType hasPrefix:@"NS"] && [subClass isKindOfClass:[NSObject class]]) {
            ivarValue = [ivarValue dicWithObject];
        }
        
        [resultDic setValue:ivarValue forKey:ivarName];
    }
    
    // 判断属性类型，根据类型来进行判断
    
    free(ivarList);
    return resultDic;
}


@end
