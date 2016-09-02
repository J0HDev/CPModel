//
//  CPCommon.h
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CPEncodingType) {
    CPEncodingTypeMask       = 0xFF, //8 bit
    CPEncodingTypeUnknown    = 0, 
    CPEncodingTypeVoid       = 1, 
    CPEncodingTypeBool       = 2, 
    CPEncodingTypeInt8       = 3, 
    CPEncodingTypeUInt8      = 4, 
    CPEncodingTypeInt16      = 5, 
    CPEncodingTypeUInt16     = 6, 
    CPEncodingTypeInt32      = 7, 
    CPEncodingTypeUInt32     = 8, 
    CPEncodingTypeInt64      = 9, 
    CPEncodingTypeUInt64     = 10,
    CPEncodingTypeFloat      = 11,
    CPEncodingTypeDouble     = 12,
    CPEncodingTypeLongDouble = 13,
    CPEncodingTypeObject     = 14,
    CPEncodingTypeClass      = 15,
    CPEncodingTypeSEL        = 16,
    CPEncodingTypeBlock      = 17,
    CPEncodingTypePointer    = 18,
    CPEncodingTypeStruct     = 19,
    CPEncodingTypeUnion      = 20,
    CPEncodingTypeCString    = 21,
    CPEncodingTypeCArray     = 22,
    
    CPEncodingTypeQualifierMask   = 0xFF00,  //16 bit
    CPEncodingTypeQualifierConst  = 1 << 8,  
    CPEncodingTypeQualifierIn     = 1 << 9,  
    CPEncodingTypeQualifierInout  = 1 << 10, 
    CPEncodingTypeQualifierOut    = 1 << 11, 
    CPEncodingTypeQualifierBycopy = 1 << 12, 
    CPEncodingTypeQualifierByref  = 1 << 13, 
    CPEncodingTypeQualifierOneway = 1 << 14,
    
    CPEncodingTypePropertyMask         = 0xFF0000, // 24 bit
    CPEncodingTypePropertyReadonly     = 1 << 16, 
    CPEncodingTypePropertyCopy         = 1 << 17, 
    CPEncodingTypePropertyRetain       = 1 << 18, 
    CPEncodingTypePropertyNonatomic    = 1 << 19, 
    CPEncodingTypePropertyWeak         = 1 << 20, 
    CPEncodingTypePropertyCustomGetter = 1 << 21, 
    CPEncodingTypePropertyCustomSetter = 1 << 22, 
    CPEncodingTypePropertyDynamic      = 1 << 23,
};

CPEncodingType CPEncodingGetType(const char *typeEncoding);