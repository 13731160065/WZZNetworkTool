//
//  ViewController.m
//  WZZNetworkTool
//
//  Created by 王泽众 on 16/5/18.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "HttpTool.h"
#import "WZZChangeConfigPopVC.h"

@interface ViewController ()<NSTableViewDataSource, NSTableViewDelegate>
{
    NSTableView * _mainTV;
    NSArray <NSTextField *>* keysArr;
    NSArray <NSTextField *>* valuesArr;
}
#pragma mark - 输入框

@property (weak) IBOutlet NSTextField *key1;
@property (weak) IBOutlet NSTextField *key2;
@property (weak) IBOutlet NSTextField *key3;
@property (weak) IBOutlet NSTextField *key4;
@property (weak) IBOutlet NSTextField *key5;
@property (weak) IBOutlet NSTextField *key6;
@property (weak) IBOutlet NSTextField *key7;
@property (weak) IBOutlet NSTextField *key8;
@property (weak) IBOutlet NSTextField *key9;
@property (weak) IBOutlet NSTextField *key10;
@property (weak) IBOutlet NSTextField *key11;
@property (weak) IBOutlet NSTextField *key12;
@property (weak) IBOutlet NSTextField *key13;
@property (weak) IBOutlet NSTextField *key14;
@property (weak) IBOutlet NSTextField *key15;
@property (weak) IBOutlet NSTextField *key16;
@property (weak) IBOutlet NSTextField *key17;
@property (weak) IBOutlet NSTextField *key18;
@property (weak) IBOutlet NSTextField *key19;
@property (weak) IBOutlet NSTextField *key20;

@property (weak) IBOutlet NSTextField *value1;
@property (weak) IBOutlet NSTextField *value2;
@property (weak) IBOutlet NSTextField *value3;
@property (weak) IBOutlet NSTextField *value4;
@property (weak) IBOutlet NSTextField *value5;
@property (weak) IBOutlet NSTextField *value6;
@property (weak) IBOutlet NSTextField *value7;
@property (weak) IBOutlet NSTextField *value8;
@property (weak) IBOutlet NSTextField *value9;
@property (weak) IBOutlet NSTextField *value10;
@property (weak) IBOutlet NSTextField *value11;
@property (weak) IBOutlet NSTextField *value12;
@property (weak) IBOutlet NSTextField *value13;
@property (weak) IBOutlet NSTextField *value14;
@property (weak) IBOutlet NSTextField *value15;
@property (weak) IBOutlet NSTextField *value16;
@property (weak) IBOutlet NSTextField *value17;
@property (weak) IBOutlet NSTextField *value18;
@property (weak) IBOutlet NSTextField *value19;
@property (weak) IBOutlet NSTextField *value20;

#pragma mark - 属性
@property (weak) IBOutlet NSTextField *requestUrlTextField;
@property (weak) IBOutlet NSScrollView *responceTextView;
@property (weak) IBOutlet NSPopUpButton *netStateMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatMainUI];
}

- (void)creatMainUI {
    [_netStateMenu removeAllItems];
    [_netStateMenu addItemWithTitle:@"get"];
    [_netStateMenu addItemWithTitle:@"post"];
    [_netStateMenu addItemWithTitle:@"put"];
    [_netStateMenu addItemWithTitle:@"delete"];
    
    keysArr = @[_key1, _key2, _key3, _key4, _key5, _key6, _key7, _key8, _key9, _key10, _key11, _key12, _key13, _key14, _key15, _key16, _key17, _key18, _key19, _key20];
    
    valuesArr = @[_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20];
    
    
    NSArray *arrayOfDocPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docPath = [arrayOfDocPath objectAtIndex:0];
    NSLog(@"%@", docPath);
}
- (IBAction)resetValues:(id)sender {
    [keysArr enumerateObjectsUsingBlock:^(NSTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        keysArr[idx].stringValue = @"";
        valuesArr[idx].stringValue = @"";
        [_netStateMenu selectItemAtIndex:0];
    }];
}

- (IBAction)requestClick:(id)sender {
    NSTextView * tvv = _responceTextView.documentView;
    NSMutableDictionary * uploadDic = [NSMutableDictionary dictionary];
    [keysArr enumerateObjectsUsingBlock:^(NSTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![keysArr[idx].stringValue isEqualToString:@""] && ![valuesArr[idx].stringValue isEqualToString:@""]) {
            [uploadDic setObject:valuesArr[idx].stringValue forKey:keysArr[idx].stringValue];
        }
    }];
    if ([_netStateMenu.selectedItem.title isEqualToString:@"get"]) {
        [HttpTool GET:_requestUrlTextField.stringValue parameters:uploadDic success:^(id responseObject) {
            NSLog(@"ok->%@", responseObject);
            NSString * jsonStr = [self arrayToJson:responseObject];
            tvv.string = jsonStr;
        } failure:^(NSError *error) {
            NSLog(@"no");
            tvv.string = [NSString stringWithFormat:@"网络请求失败，错误信息如下：\n%@", error];
        }];
    } else if ([_netStateMenu.selectedItem.title isEqualToString:@"post"]) {
        [HttpTool POST:_requestUrlTextField.stringValue parameters:uploadDic success:^(id responseObject) {
            NSLog(@"ok->%@", responseObject);
            NSString * jsonStr = [self arrayToJson:responseObject];
            tvv.string = jsonStr;
        } failure:^(NSError *error) {
            NSLog(@"no");
            tvv.string = [NSString stringWithFormat:@"网络请求失败，错误信息如下：\n%@", error];
        }];
    } else if ([_netStateMenu.selectedItem.title isEqualToString:@"put"]) {
        [HttpTool PUT:_requestUrlTextField.stringValue parameters:uploadDic success:^(id responseObject) {
            NSLog(@"ok->%@", responseObject);
            NSString * jsonStr = [self arrayToJson:responseObject];
            tvv.string = jsonStr;
        } failure:^(NSError *error) {
            NSLog(@"no");
            tvv.string = [NSString stringWithFormat:@"网络请求失败，错误信息如下：\n%@", error];
        }];
    } else if ([_netStateMenu.selectedItem.title isEqualToString:@"delete"]) {
        [HttpTool DELETE:_requestUrlTextField.stringValue parameters:uploadDic success:^(id responseObject) {
            NSLog(@"ok->%@", responseObject);
            NSString * jsonStr = [self arrayToJson:responseObject];
            tvv.string = jsonStr;
        } failure:^(NSError *error) {
            NSLog(@"no");
            tvv.string = [NSString stringWithFormat:@"网络请求失败，错误信息如下：\n%@", error];
        }];
    }
    
}

//数组转json
- (id)arrayToJson:(id)obj {
    if (!obj) {
        return @"null";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 代理方法
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 10;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextFieldCell * cell = [[NSTextFieldCell alloc] initTextCell:@""];
    [cell setPlaceholderString:@"请输入请求参数键"];
    return cell;
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"input"]) {
        WZZChangeConfigPopVC * vcc = (WZZChangeConfigPopVC *)segue.destinationController;
        vcc.isInput = YES;
    } else if ([segue.identifier isEqualToString:@"output"]) {
        WZZChangeConfigPopVC * vcc = (WZZChangeConfigPopVC *)segue.destinationController;
        vcc.isInput = NO;
    }
}

@end
