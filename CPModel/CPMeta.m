//
//  CPCPModelPropertyMeta.m
//  CPModel
//
//  Created by 业王 on 16/8/27.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import "CPMeta.h"
#import "CPClassPropertyInfo.h"
#import "CPClassInfo.h"
#import "CPCommon.h"

#define force_inline __inline__ __attribute__((always_inline))

static force_inline CPEncodingNSType CPClassGetNSType(Class cls) {
    if (!cls) return CPEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return CPEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return CPEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return CPEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return CPEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return CPEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return CPEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return CPEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return CPEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return CPEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return CPEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return CPEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return CPEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return CPEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return CPEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return CPEncodingTypeNSSet;
    return CPEncodingTypeNSUnknown;
}

static force_inline BOOL CPEncodingTypeIsCNumber(CPEncodingType type) {
    switch (type & CPEncodingTypeMask) {
        case CPEncodingTypeBool:
        case CPEncodingTypeInt8:
        case CPEncodingTypeUInt8:
        case CPEncodingTypeInt16:
        case CPEncodingTypeUInt16:
        case CPEncodingTypeInt32:
        case CPEncodingTypeUInt32:
        case CPEncodingTypeInt64:
        case CPEncodingTypeUInt64:
        case CPEncodingTypeFloat:
        case CPEncodingTypeDouble:
        case CPEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

@implementation CPModelPropertyMeta

+ (instancetype)modelWithClassInfo:(CPClassInfo *)clsInfo propretyInfo:(CPClassPropertyInfo *)propertyInfo generic:(Class)generic{
    CPModelPropertyMeta *meta = [self new];
    meta->_name = propertyInfo.name;
    meta->_type = propertyInfo.type;
    meta->_info = propertyInfo;
    meta->_genericCls = generic;
    
    if ((meta->_type & CPEncodingTypeMask) == CPEncodingTypeObject) {
        meta->_nsType = CPClassGetNSType(propertyInfo.cls);
    } else {
        meta->_isCNumber = CPEncodingTypeIsCNumber(meta->_type);
    }
    
    meta->_cls = propertyInfo.cls;
    
    if (propertyInfo.getter) {
        if ([clsInfo.cls instancesRespondToSelector:propertyInfo.getter]) {
            meta->_getter = propertyInfo.getter;
        }
    }
    
    if (propertyInfo.setter) {
        if ([clsInfo.cls instancesRespondToSelector:propertyInfo.setter]) {
            meta->_setter = propertyInfo.setter;
        }
    }
    
    if (meta->_setter && meta->_getter) {
        switch (meta->_type & CPEncodingTypeMask) {
            case CPEncodingTypeBool:
            case CPEncodingTypeInt8:
            case CPEncodingTypeUInt8:
            case CPEncodingTypeInt16:
            case CPEncodingTypeUInt16:
            case CPEncodingTypeInt32:
            case CPEncodingTypeUInt32:
            case CPEncodingTypeInt64:
            case CPEncodingTypeUInt64:
            case CPEncodingTypeFloat:
            case CPEncodingTypeDouble:
            case CPEncodingTypeObject:
            case CPEncodingTypeClass:
            case CPEncodingTypeBlock:
            case CPEncodingTypeStruct:
            case CPEncodingTypeUnion: {
                meta->_isKVCCompatible = YES;
            } break;
            default: break;
        }
    }
    
    return meta;
}

@end

@implementation CPModelMeta

- (instancetype)initWithClass:(Class)cls{
    if (!cls) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        CPClassInfo *clsInfo = [CPClassInfo classInfoWithClass:cls];
        NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
        CPClassInfo *curClsInfo = clsInfo;
        //连同当前的类和其父类的属性一起放入allPropertyMetas数组，(NSObject和NSProxy是没有父类的）
        while (curClsInfo && curClsInfo.superClass != nil) {
            for (CPClassPropertyInfo *propertyInfo in curClsInfo.propertyInfos.allValues) {
                if (!propertyInfo.name)continue;
                CPModelPropertyMeta *meta = [CPModelPropertyMeta modelWithClassInfo:clsInfo propretyInfo:propertyInfo generic:nil];
                if (!meta || !meta->_name)continue;
                if (!meta->_setter || !meta->_getter)continue;
                if (allPropertyMetas[meta->_name])continue;
                allPropertyMetas[meta->_name] = meta;
            }
            curClsInfo = clsInfo.superClassInfo;
        }
        
        if (allPropertyMetas.count) {
            _allPropertyMetas = allPropertyMetas.allValues.copy;
        }
        
        NSMutableDictionary *mapper = [NSMutableDictionary new];
        
        [allPropertyMetas enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull name, CPModelPropertyMeta *  _Nonnull meta, BOOL * _Nonnull stop) {
            meta->_mappedToKey = name;
            mapper[name] = meta;
        }];
        
        if (mapper.count) _mapper = mapper;
        _clsInfo = clsInfo;
        _keyMappedCount = _allPropertyMetas.count;
        _nsType = CPClassGetNSType(cls);
        
    }
    return self;
}

+ (instancetype)metaWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    
    //执行一次，初始化一个cache和一个同步锁
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    
    //保证一次只有一个线程来取缓存
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CPModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    dispatch_semaphore_signal(lock);
    
    //缓存没有命中或需要更新时，重新实例化一个_YYModelMeta，然后丢进缓存
    if (!meta || meta->_clsInfo.needUpdate) {
        meta = [[CPModelMeta alloc] initWithClass:cls]; //代码的关键在 initWithClass:
        if (meta) {
            
            //同步锁，保证只有一个线程访问缓存
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            dispatch_semaphore_signal(lock);
        }
    }
    return meta;
}

@end
