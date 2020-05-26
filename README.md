[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
此框架采用runtime打造的高效的iOS解析库，有字典转模型、模型转字典等。
* [X] 支持字典、字符串(Json结构)、NSData转模型
* [X] 支持模型转字典、字符串(Json结构)、NSData
* [X] 支持用户自定义映射字段

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


### 设计思路(有兴趣可以看)

#### 类说明
* NSObject+QSModel分类：为方便调用采用分类设计，所有的逻辑实现都在这个分类里面实现，其核心部分就是字典转模型、模型转字典两大类，其它的比如字符串、NSData转模型都是先转化为字典，再转化为模型，字典相当于一个中间者。

#### 思路图解

字典转模型：
> 1. 把模型的所有成员变量名称、变量类型、映射后的变量名称拿到
> 2. 遍历成员变，根据预设值类型和变量类型不同，针对数组、字典、日期等处理
> 3. 把处理后的结果使用KVC给空对象赋值
![image](https://github.com/wuqiushan/QSModel-ObjC/blob/master/字典转模型.jpg)

模型转字典：
> 1. 与字典转模型一样，不同之处在于，变量类型处理顺序，因为要顾及到各种类型这里把数组优先处理，最后处理映射，这样映射处理权重最高。
![image](https://github.com/wuqiushan/QSModel-ObjC/blob/master/模型转字典.jpg)
