//
//  WZZPropertyVC.m
//  WZZNetworkTool
//
//  Created by 王泽众 on 16/5/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZPropertyVC.h"

@interface WZZPropertyVC ()

@property (unsafe_unretained) IBOutlet NSTextView *text1;
@property (unsafe_unretained) IBOutlet NSTextView *text2;


@end

@implementation WZZPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)exchangeClick:(id)sender {
    NSDictionary * dic = [self dictionaryWithJsonString:_text1.string];
    if (dic) {
        NSMutableArray * keysArr = [NSMutableArray array];
        NSMutableArray * valuesArr = [NSMutableArray array];
        [[dic allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [keysArr addObject:obj];
            [valuesArr addObject:dic[obj]];
        }];
        __block NSString
        * resultStr = @"";
        [valuesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj class] isSubclassOfClass:[NSString class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSString * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSNumber * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSArray class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSArray * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSDictionary class]]){
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSDictionary * %@;\n", keysArr[idx]];
            } else {
                NSLog(@"转换失败->%ld", idx);
            }
        }];
        _text2.string = resultStr;
    } else {
        _text2.string = @"json串有误，或不是字典";
    }
}
- (IBAction)exchangeWithXcode:(id)sender {
    NSDictionary * dic = [self dictionaryWithJsonString:[self xcodeToJson:_text1.string]];
    if (dic) {
        NSMutableArray * keysArr = [NSMutableArray array];
        NSMutableArray * valuesArr = [NSMutableArray array];
        [[dic allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [keysArr addObject:obj];
            [valuesArr addObject:dic[obj]];
        }];
        __block NSString
        * resultStr = @"";
        [valuesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj class] isSubclassOfClass:[NSString class]]) {
                BOOL isString = NO;
                for (int i = 0; i < ((NSString *)obj).length; i++) {
                    char objChar = [obj characterAtIndex:i];
                    if (objChar < '0' || objChar > '9') {
                        //字符，字符串类型
                        isString = YES;
                    }
                }
                if (isString) {
                    resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSString * %@;\n", keysArr[idx]];
                } else {
                    resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSNumber * %@;\n", keysArr[idx]];
                }
            } else if ([[obj class] isSubclassOfClass:[NSArray class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSArray * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSDictionary class]]){
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSDictionary * %@;\n", keysArr[idx]];
            } else {
                NSLog(@"转换失败->%ld", idx);
            }
        }];
        _text2.string = resultStr;
    } else {
        _text2.string = @"json串有误，或不是字典";
    }
}

- (NSString *)xcodeToJson:(NSString *)dicStr {
    NSLog(@"1.%@", dicStr);dicStr = [[dicStr componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    NSLog(@"2.%@", dicStr);
    dicStr = [[dicStr componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    NSLog(@"3.%@", dicStr);
    dicStr = [[dicStr componentsSeparatedByString:@";}"] componentsJoinedByString:@"}"];
    NSLog(@"4.%@", dicStr);
    dicStr = [[dicStr componentsSeparatedByString:@";"] componentsJoinedByString:@","];
    dicStr = [[dicStr componentsSeparatedByString:@"="] componentsJoinedByString:@":"];
    NSLog(@"5.%@", dicStr);
    dicStr = [[dicStr componentsSeparatedByString:@"{"] componentsJoinedByString:@"{\""];
    dicStr = [[dicStr componentsSeparatedByString:@":"] componentsJoinedByString:@"\":\""];
    dicStr = [[dicStr componentsSeparatedByString:@","] componentsJoinedByString:@"\",\""];
    dicStr = [[dicStr componentsSeparatedByString:@"}"] componentsJoinedByString:@"\"}"];
    NSLog(@"6.%@", dicStr);
    dicStr = [[dicStr componentsSeparatedByString:@"\"\""] componentsJoinedByString:@"\""];
    dicStr = [[dicStr componentsSeparatedByString:@"\"{"] componentsJoinedByString:@"{"];
    dicStr = [[dicStr componentsSeparatedByString:@"}\""] componentsJoinedByString:@"}"];
    NSLog(@"ok:%@", dicStr);
    return dicStr;
}

- (IBAction)backClick:(id)sender {
    [self dismissViewController:self];
}

//json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//数组转json
- (NSString*)arrayToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
