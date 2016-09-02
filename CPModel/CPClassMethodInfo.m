//
//  CPClassMethodInfo.m
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import "CPClassMethodInfo.h"

@implementation CPClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) {
        return nil;
    }
    
    self = [super init];
    if (self){
        _method = method;
        _sel = method_getName(method);
        _imp = method_getImplementation(method);
        const char *name = sel_getName(_sel);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        const char *typeEncoding = method_getTypeEncoding(method);
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        }
        char *returnTypeEncoding = method_copyReturnType(method);
        if (returnTypeEncoding) {
            _returnTypeEncoding = [NSString stringWithUTF8String:returnTypeEncoding];
            free(returnTypeEncoding);
        }
        
        //得到参数的数目，遍历取得所有参数的类型
        unsigned int count = method_getNumberOfArguments(method);
        if (count > 0) {
            NSMutableArray *types = [[NSMutableArray alloc] initWithCapacity:10];
            for (unsigned int i = 0; i < count; i++) {
                char *argumentsType = method_copyArgumentType(method, i);
                NSString *type = argumentsType ? [NSString stringWithUTF8String:argumentsType] : nil;
                [types addObject:type ? type : @""];
                if (argumentsType) {
                    free(argumentsType);
                }
            }
            _argumentTypeEncodings = types;
        }
        
    }
    
    return self;
}

@end
