//
//  main.m
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CPModel.h"
#import "CPTestModel.h"
#import "CPCommon.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        CPTestModel *model = [CPTestModel modelWithJSON:@"{\"name\": \"Harry Potter\",\"index\": 512,\"number\": 10,\"num\": 100}"];
        
        NSLog(@"%@ - %@ - %@ - %@",model.class, [model class], object_getClass(model), [CPTestModel class]);
        NSLog(@"%p - %p - %p - %p - %p",model.class, [model class], object_getClass(model), [CPTestModel class], object_getClass(model.class));
        
        //@"{\"name\": \"Harry Potter\",\"pages\": 512,\"date\": \"2010-01-01\"}"
        
//        CPEncodingType type = CPEncodingTypeDouble | CPEncodingTypePropertyRetain;
//        NSLog(@"%lu",type & CPEncodingTypeMask);
    }
    return 0;
}
