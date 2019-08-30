//
//  NSObject+QSModel.h
//  QSModel
//
//  Created by wuqiushan on 2019/8/29.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QSModel)

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (NSDictionary *)dicWithObject;

@end

NS_ASSUME_NONNULL_END
