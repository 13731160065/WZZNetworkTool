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
        __block NSString * resultStr = @"";
        [valuesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj class] isSubclassOfClass:[NSString class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (copy, nonatomic) NSString * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSNumber * %@;\n", keysArr[idx]];
            } else if ([[obj class] isSubclassOfClass:[NSArray class]]) {
                resultStr = [resultStr stringByAppendingFormat:@"@property (strong, nonatomic) NSArray * %@;\n", keysArr[idx]];
            } else {
                NSLog(@"转换失败->%ld", idx);
            }
        }];
        _text2.string = resultStr;
    } else {
        _text2.string = @"json串有误，或不是字典";
    }
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

@end
