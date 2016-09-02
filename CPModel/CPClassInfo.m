//
//  CPClassInfo.m
//  CPModel
//
//  Created by 业王 on 16/8/25.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import "CPClassInfo.h"
#import "CPClassIvarInfo.h"
#import "CPClassPropertyInfo.h"
#import "CPClassMethodInfo.h"

@implementation CPClassInfo{
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls{
    if (!cls) {
        return nil;
    }
    self = [super init];
    if (self) {
        _cls = cls;
        _superClass = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        if (_isMeta) {
            _metaClass = objc_getMetaClass(class_getName(cls));
        }
        _name = NSStringFromClass(cls);
        [self _update];
        
        _superClassInfo = [self.class classInfoWithClass:_superClass];
    }
    return self;
}

- (void)_update{
    _ivarInfos = nil;
    _propertyInfos = nil;
    _methodInfos = nil;
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(self.cls, &ivarCount);
    if (ivars) {
        _ivarInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < ivarCount; i++) {
            CPClassIvarInfo *ivarInfo = [[CPClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (ivarInfo.name) {
                [_ivarInfos setValue:ivarInfo forKey:ivarInfo.name];
            }
        }
        free(ivars);
    }
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.cls, &propertyCount);
    if (properties) {
        _propertyInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < propertyCount; i++) {
            CPClassPropertyInfo *propertyInfo = [[CPClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (propertyInfo.name) {
                [_propertyInfos setValue:propertyInfo forKey:propertyInfo.name];
            }
        }
        free(properties);
    }
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(self.cls, &methodCount);
    if (methods) {
        _methodInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < methodCount; i++) {
            CPClassMethodInfo *methodInfo = [[CPClassMethodInfo alloc] initWithMethod:methods[i]];
            if (methodInfo.name) {
                [_methodInfos setValue:methodInfo forKey:methodInfo.name];
            }
        }
        free(methods);
    }
    
    if (!_ivarInfos) {
        _ivarInfos = @{};
    }
    if (!_methodInfos) {
        _methodInfos = @{};
    }
    if (!_propertyInfos) {
        _propertyInfos = @{};
    }
    _needUpdate = NO;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

- (void)setNeedUpadte {
    _needUpdate = YES;
}

+ (instancetype)classInfoWithClass:(Class)cls{
    if (!cls) {
        return nil;
    }
    
    static NSMutableDictionary *metaCache;
    static NSMutableDictionary *classCache;
    static dispatch_semaphore_t lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        metaCache = [NSMutableDictionary dictionary];
        classCache = [NSMutableDictionary dictionary];
        lock = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CPClassInfo *info;
    if (class_isMetaClass(cls)) {
        info = [metaCache valueForKey:NSStringFromClass(cls)];
    } else {
        info = [classCache valueForKey:NSStringFromClass(cls)];
    }
    if (info && info->_needUpdate) {
        [info _update];
    }
    dispatch_semaphore_signal(lock);
    
    if (!info) {
        info = [[CPClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            if (info.isMeta) {
                [metaCache setValue:info forKey:NSStringFromClass(cls)];
            } else {
                [classCache setValue:info forKey:NSStringFromClass(cls)];
            }
            dispatch_semaphore_signal(lock);
        }
    }
    
    return info;
}

@end
