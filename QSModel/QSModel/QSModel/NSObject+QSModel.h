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

+ (instancetype)qs_modelWithDictionary:(NSDictionary *)dic;
+ (instancetype)qs_modelWithString:(NSString *)str;
+ (instancetype)qs_modelWithData:(NSData *)data;

- (NSDictionary *)qs_modelToDictionary;
- (NSString *)qs_modelToJSONString;
- (NSData *)qs_modelToJSONData;


@end

NS_ASSUME_NONNULL_END
