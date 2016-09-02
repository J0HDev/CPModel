//
//  CPClassIvarInfo.m
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import "CPClassIvarInfo.h"

@implementation CPClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar){
        return nil;
    }
    
    self = [super init];
    if (self){
        _ivar = ivar;
        const char *name = ivar_getName(ivar);
        if (name){
            _name = [NSString stringWithUTF8String:name];
        }
        const char *typeEncoding = ivar_getTypeEncoding(ivar);
        if (typeEncoding){
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
            _type = CPEncodingGetType(typeEncoding);
        }
    }
    return self;
}

@end
