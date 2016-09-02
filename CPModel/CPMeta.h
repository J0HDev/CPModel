//
//  CPYYModelPropertyMeta.h
//  CPModel
//
//  Created by 业王 on 16/8/27.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "CPCommon.h"
@class CPClassInfo;
@class CPClassPropertyInfo;

typedef NS_ENUM (NSUInteger, CPEncodingNSType) {
    CPEncodingTypeNSUnknown = 0,
    CPEncodingTypeNSString,
    CPEncodingTypeNSMutableString,
    CPEncodingTypeNSValue,
    CPEncodingTypeNSNumber,
    CPEncodingTypeNSDecimalNumber,
    CPEncodingTypeNSData,
    CPEncodingTypeNSMutableData,
    CPEncodingTypeNSDate,
    CPEncodingTypeNSURL,
    CPEncodingTypeNSArray,
    CPEncodingTypeNSMutableArray,
    CPEncodingTypeNSDictionary,
    CPEncodingTypeNSMutableDictionary,
    CPEncodingTypeNSSet,
    CPEncodingTypeNSMutableSet,
};

@interface CPModelMeta : NSObject{
    @package
    CPClassInfo *_clsInfo;
    NSDictionary *_mapper;
    NSArray *_allPropertyMetas;
    NSUInteger _keyMappedCount;
    CPEncodingNSType _nsType;
}

+ (instancetype)metaWithClass:(Class)cls;

@end

@interface CPModelPropertyMeta : NSObject{
    @package
    NSString *_name;
    CPEncodingType _type;
    CPEncodingNSType _nsType;
    BOOL _isCNumber;
    Class _cls;
    Class _genericCls;
    SEL _getter;
    SEL _setter;
    BOOL _isKVCCompatible;
    NSString *_mappedToKey;
    CPClassPropertyInfo *_info;
}

+ (instancetype)modelWithClassInfo:(CPClassInfo *)clsInfo propretyInfo:(CPClassPropertyInfo *)propertyInfo generic:(Class)generic;

@end
