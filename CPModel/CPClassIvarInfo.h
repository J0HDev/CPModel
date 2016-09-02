//
//  CPClassIvarInfo.h
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "CPCommon.h"

@interface CPClassIvarInfo : NSObject

@property (nonatomic, assign, readonly) Ivar ivar;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, assign, readonly) CPEncodingType type;

- (instancetype)initWithIvar:(Ivar)ivar;

@end
