//
//  CPClassPropertyInfo.h
//  CPModel
//
//  Created by 业王 on 16/8/24.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "CPCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPClassPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) CPEncodingType type;
@property (nonatomic, strong, readonly) NSString *typdEncoding;
@property (nonatomic, strong, readonly) NSString *ivarName;
@property (nullable, nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;

- (instancetype)initWithProperty:(objc_property_t)property;

NS_ASSUME_NONNULL_END

@end
