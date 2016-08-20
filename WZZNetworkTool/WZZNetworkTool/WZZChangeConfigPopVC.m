//
//  WZZChangeConfigPopVC.m
//  WZZNetworkTool
//
//  Created by 王泽众 on 16/5/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZChangeConfigPopVC.h"

@interface WZZChangeConfigPopVC ()
{
    void(^_inputBlock)(NSString *);
}

/**
 路径头
 */
@property (weak) IBOutlet NSPopUpButton *pathHeader;

/**
 路径体
 */
@property (weak) IBOutlet NSTextField *pathBody;

/**
 导入导出按钮
 */
@property (weak) IBOutlet NSButton *clickButton;

/**
 错误信息
 */
@property (unsafe_unretained) IBOutlet NSTextView *errorTextView;

@property (weak) IBOutlet NSPopUpButton *selectButton;


@end

@implementation WZZChangeConfigPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_selectButton removeAllItems];
    [_selectButton addItemsWithTitles:@[@"桌面", @"文档", @"下载"]];
    
    if (_isInput) {
        [_clickButton setTitle:@"导入"];
    } else {
        [_clickButton setTitle:@"导出"];
    }
}

//导入导出
- (IBAction)okClick:(id)sender {
    NSInteger selectIdx = 0;
    if ([_selectButton.title isEqualToString:@"桌面"]) {
        selectIdx = 0;
    } else if ([_selectButton.title isEqualToString:@"文档"]) {
        selectIdx = 1;
    } else {
        selectIdx = 2;
    }
    //头路径
    NSString * headerPath = [self getPathWithIdx:selectIdx];
    //全路径
    NSString * fullPath = @"";
    if ([_pathBody.stringValue isEqualToString:@""]) {
        fullPath = [headerPath stringByAppendingString:@"/WZZNetworkToolOutPutFile"];
    } else {
        if ([_pathBody.stringValue hasPrefix:@"/"]) {
            fullPath = [headerPath stringByAppendingString:_pathBody.stringValue];
        } else {
            fullPath = [headerPath stringByAppendingString:[@"/" stringByAppendingString:_pathBody.stringValue]];
        }
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (_isInput) {
        //导入
        
        NSOpenPanel* openPanel = [NSOpenPanel openPanel];
        //            [openPanel setAllowedFileTypes:@[@"zz"]];
        [openPanel setMessage:@"选择文件"];
        [openPanel setPrompt:@"选择"];
        NSInteger result =[openPanel runModal];
        
        if (result == NSFileHandlingPanelOKButton) {
            
            if ([fileManager fileExistsAtPath:fullPath]) {
                NSString * loadStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:openPanel.URL] encoding:NSUTF8StringEncoding];
                if ([loadStr isEqualToString:@""]) {
                    _errorTextView.string = @"文件中没有东西";
                } else {
                    _errorTextView.string = @"导入成功";
                }
                if (_inputBlock) {
                    _inputBlock(loadStr);
                }
            } else {
                _errorTextView.string = @"文件不存在";
            }
            
        }
        
    } else {
        //导出
        if ([fileManager fileExistsAtPath:fullPath]) {
            _errorTextView.string = @"文件已存在";
        } else {
            if ([fileManager createFileAtPath:fullPath contents:[_outputReqStr dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
                _errorTextView.string = @"导出成功";
            } else {
                _errorTextView.string = @"创建失败，可能是路径有误";
            }
        }
    }
}

- (void)blockWithInput:(void (^)(NSString *))inputBlock {
    if (_inputBlock != inputBlock) {
        _inputBlock = inputBlock;
    }
}

- (NSString *)getPathWithIdx:(NSInteger)idx {
    NSSearchPathDirectory ddd;
    switch (idx) {
        case 0:
        {
            //桌面
            ddd = NSDesktopDirectory;
        }
            break;
        case 1:
        {
            //文档
            ddd = NSDocumentDirectory;
        }
            break;
        case 2:
        {
            //下载
            ddd = NSDownloadsDirectory;
        }
            break;
            
        default:
            break;
    }
    NSArray *arrayOfDocPath =NSSearchPathForDirectoriesInDomains(ddd,NSUserDomainMask,YES);
    return [arrayOfDocPath objectAtIndex:0];
}

@end
