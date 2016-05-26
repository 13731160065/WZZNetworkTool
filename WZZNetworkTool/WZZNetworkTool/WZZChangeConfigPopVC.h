//
//  WZZChangeConfigPopVC.h
//  WZZNetworkTool
//
//  Created by 王泽众 on 16/5/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WZZChangeConfigPopVC : NSViewController

@property (assign, nonatomic) BOOL isInput;

@property (copy, nonatomic) NSString * outputReqStr;

- (void)blockWithInput:(void(^)(NSString * reqStr))inputBlock;

@end
