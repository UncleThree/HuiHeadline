//
//  EntryNeed.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "EntryNeed.h"

@implementation EntryNeed

+ (NSArray <NSNumber *>*)shortKey:(NSString *)shortKey {
    
    NSMutableArray *shortKeyList = [NSMutableArray array];
    const char *chars = [shortKey cStringUsingEncoding:[NSString defaultCStringEncoding]];
    for (int i = 0; i < shortKey.length; i++) {
        int x = (int)chars[i];
        if (i < 2) {
            int y = x % 8;
            if (y <= 3) {
                y = 3;
            }
            [shortKeyList addObject:[NSNumber numberWithInt:y]];
        } else {
            int y = x % 4;
            [shortKeyList addObject:[NSNumber numberWithInt:y]];
        }
    }
    
    return shortKeyList;
}
//获取从右向左的字符串
+ (NSString *)getTail:(NSString *)str
             position:(NSUInteger)position  {
    NSString *tailFirst = [str substringWithRange:NSMakeRange(str.length - position, position)];
    NSMutableString *sb = [NSMutableString string];
    for (int i = (int)tailFirst.length; i > 0 ; i--) {
        [sb appendString:[tailFirst substringWithRange:NSMakeRange(i - 1, 1)]];
    }
    return sb.copy;
}

+ (NSArray<NSArray<NSString *> *> *)before:(NSString *)_left
              :(NSString *)_rigth {
    NSMutableArray *list = [NSMutableArray array];
    NSMutableArray *left = [NSMutableArray array];
    NSMutableArray *right = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0 ; i < _left.length; i++) {
        [left addObject:[_left substringWithRange:NSMakeRange(i, 1)]];
    }
    for (int j = 0 ; j < _left.length; j++) {
        [right addObject:[_rigth substringWithRange:NSMakeRange(j, 1)]];
    }
    int i = (int)(left.count - right.count);
    if (i > 0) {
        [temp addObjectsFromArray:right];
        [temp addObjectsFromArray:right];
        for (int k = 0; k < i; k++) {
            [right addObject:temp[k]];
        }
    } else if (i < 0) {
        i = 0 - i;
        [temp addObjectsFromArray:left];
        [temp addObjectsFromArray:left];
        for (int k = 0; k < i; k++) {
            [left addObject:temp[k]];
        }
    }
    [list addObject:left];
    [list addObject:right];
    return list.copy;
    
}

+ (NSString *)hexString:(NSArray *)format
                   type:(NSString *)type{
    
    NSArray *left = format[0];
    NSArray *right = format[1];
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < left.count; i++) {
        int x = [self toCharArray:left[i]][0];
        int y = [self toCharArray:right[i]][0];
        NSString *xy = nil;
        if ([type isEqualToString:@"+"]) {
            xy = [self stringWithHexNumber:x + y];
        } else if ([type isEqualToString:@"-"]) {
            int tem =  x - y;
            if (tem < 0) {
                tem = -tem;
            }
            xy = [self stringWithHexNumber:tem];
        } else if ([type isEqualToString:@"&"]) {
            xy = [self stringWithHexNumber:x & y];
        } else if ([type isEqualToString:@"^"]) {
            xy = [self stringWithHexNumber:x ^ y];
        } else {
            NSLog(@"WTF");
        }
        
        if (xy.length < 2) {
            [result appendString:@"0"];
        }
        [result appendString:xy];
    }
    if (left.count < 8) {
        for (int j = 0; j < 8 - left.count; j++) {
            [result appendString:@"00"];
        }
    }
    return result;
    
}


+ (NSString *)add:(NSString *)_left
                 :(NSString *)_right {
    
    NSString *hexString = [self hexString:[self before:_left :_right] type:@"+"];
    NSString *result = [self numberHexString:hexString];
    return result;
}

+ (NSString *)reduce:(NSString *)_left
                    :(NSString *)_right {
    
    //16进制字符串
    NSString *hexString = [self hexString:[self before:_left :_right] type:@"-"];
    //10进制字符串
    NSString *result = [self numberHexString:hexString];
    return result;
}

+ (NSString *)and:(NSString *)_left
                 :(NSString *)_right {
    
    NSString *hexString = [self hexString:[self before:_left :_right] type:@"&"];
    NSString *result = [self numberHexString:hexString];
    return result;
}

+ (NSString *)or:(NSString *)_left
                :(NSString *)_right {
    NSString *hexString = [self hexString:[self before:_left :_right] type:@"^"];
    NSString *result = [self numberHexString:hexString];
    return result;
}

+ (const char *)toCharArray:(NSString *)str {
    
    return [str cStringUsingEncoding:[NSString defaultCStringEncoding]];
}

//数字转16进制字符串
+ (NSString *)stringWithHexNumber:(int)hexNumber{
    long long int tmpid = hexNumber;
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
   
}
// 16进制转10进制数字
+ (NSString *) numberHexString:(NSString *)aHexString
{
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    NSString *result = [NSString stringWithFormat:@"%lld", longlongValue];
    return result;
}

//16 -> data
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}



@end
