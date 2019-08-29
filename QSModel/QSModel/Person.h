//
//  Person.h
//  QSModel
//
//  Created by apple on 2019/8/28.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) int *age;

- (void)setWeight:(NSString *)weight;
- (NSString *)Weight;

@end

NS_ASSUME_NONNULL_END
