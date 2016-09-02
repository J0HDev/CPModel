//
//  CPClassInfo.h
//  CPModel
//
//  Created by 业王 on 16/8/25.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class CPClassIvarInfo;
@class CPClassMethodInfo;
@class CPClassPropertyInfo;

NS_ASSUME_NONNULL_BEGIN

@interface CPClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) Class superClass;
@property (nonatomic, assign, readonly) Class metaClass;
@property (nonatomic, readonly) BOOL isMeta;
@property (nonatomic, strong, readonly) NSString *name;
@property (nullable, nonatomic, strong, readonly) CPClassInfo *superClassInfo;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CPClassIvarInfo *> *ivarInfos;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CPClassMethodInfo *> *methodInfos;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CPClassPropertyInfo *> *propertyInfos;

- (void)setNeedUpadte;
- (BOOL)needUpdate;
+ (nullable instancetype)classInfoWithClass:(Class)cls;

NS_ASSUME_NONNULL_END

@end
