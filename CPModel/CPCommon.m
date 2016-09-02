//
//  CPCommon.m
//  CPModel
//
//  Created by 业王 on 16/8/23.
//  Copyright © 2016年 j0hdev. All rights reserved.
//

#import "CPCommon.h"

CPEncodingType CPEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return CPEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return CPEncodingTypeUnknown;
    
    CPEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= CPEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= CPEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= CPEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= CPEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= CPEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= CPEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= CPEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return CPEncodingTypeUnknown | qualifier;
    
    switch (*type) {
        case 'v': return CPEncodingTypeVoid | qualifier;
        case 'B': return CPEncodingTypeBool | qualifier;
        case 'c': return CPEncodingTypeInt8 | qualifier;
        case 'C': return CPEncodingTypeUInt8 | qualifier;
        case 's': return CPEncodingTypeInt16 | qualifier;
        case 'S': return CPEncodingTypeUInt16 | qualifier;
        case 'i': return CPEncodingTypeInt32 | qualifier;
        case 'I': return CPEncodingTypeUInt32 | qualifier;
        case 'l': return CPEncodingTypeInt32 | qualifier;
        case 'L': return CPEncodingTypeUInt32 | qualifier;
        case 'q': return CPEncodingTypeInt64 | qualifier;
        case 'Q': return CPEncodingTypeUInt64 | qualifier;
        case 'f': return CPEncodingTypeFloat | qualifier;
        case 'd': return CPEncodingTypeDouble | qualifier;
        case 'D': return CPEncodingTypeLongDouble | qualifier;
        case '#': return CPEncodingTypeClass | qualifier;
        case ':': return CPEncodingTypeSEL | qualifier;
        case '*': return CPEncodingTypeCString | qualifier;
        case '^': return CPEncodingTypePointer | qualifier;
        case '[': return CPEncodingTypeCArray | qualifier;
        case '(': return CPEncodingTypeUnion | qualifier;
        case '{': return CPEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return CPEncodingTypeBlock | qualifier;
            else
                return CPEncodingTypeObject | qualifier;
        }
        default: return CPEncodingTypeUnknown | qualifier;
    }
}