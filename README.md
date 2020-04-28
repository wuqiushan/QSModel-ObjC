[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
此框架采用runtime打造的高效的iOS解析库，有字典转模型、模型转字典等。
```Objective-C
+ (instancetype)qs_modelWithDictionary:(NSDictionary *)dic;
+ (instancetype)qs_modelWithString:(NSString *)str;
+ (instancetype)qs_modelWithData:(NSData *)data;

- (NSDictionary *)qs_dictionaryWithModel;
- (NSString *)qs_stringWithModel;
- (NSData *)qs_dataWithModel;
```

### 使用方法
```Objective-C
 #pragma mark -- runtime 字典转模型
- (void)testQSModel {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Student" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    Student *student1 = [Student qs_modelWithData:data];
    NSDictionary *result = [student1 qs_dictionaryWithModel];
}
```

### 许可证
所有源代码均根据MIT许可证进行许可。