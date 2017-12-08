//
//  HHUtils.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUtils.h"
#import <SDWebImage/SDImageCache.h>

@implementation HHUtils

+ (NSString *)insertComma:(NSString *)num {
    
    
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
    
    
}

+ (NSString *)phone_sec:(NSString *)phone {
    
    if (phone.length >= 7) {
        return [phone stringByReplacingCharactersInRange:(NSMakeRange(3, 4)) withString:@"****"];
    }
    return nil;
        
    
}


//手机号有效性
+ (BOOL)isMobileNumber:(NSString *)str {
    
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:str];
}

 //邮箱
+ (BOOL)isEmailAddress:(NSString *)str {
    
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex string:str];
    
}

+ (BOOL)isValidateByRegex:(NSString *)regex
                   string:(NSString *)string {
    
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
     return [pre evaluateWithObject:string];
    
}

+ (BOOL)isOnlyChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}



+ (BOOL)isNameValid:(NSString *)name
{
    BOOL isValid = NO;
    
    if (name.length > 0)
    {
        for (NSInteger i=0; i<name.length; i++)
        {
            unichar chr = [name characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else if (chr == '-' || chr == '_')
                {
                    isValid = YES;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}



+ ( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath :cachePath];
    
}



// 遍历文件夹获得文件夹大小，返回多少 M
+ ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
    
}

// 计算 单个文件的大小

+ ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}


+ (void)clearFile:(void(^)(NSString *cache))callback
{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cacheString = [self getSDCacheSize];
        NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
        NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
        //NSLog ( @"cachpath = %@" , cachePath);
        for ( NSString * p in files) {
            
            NSError * error = nil ;
            //获取文件全路径
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
            
            if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
                [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
            }
        }
        
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(cacheString);
            });
            
        }];
        
    });

}


+ (NSString *)getSDCacheSize {
    
    
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    //
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
    
    return currentVolum;
}


//计算出大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size / 1024.0f;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size / (1024 * 1024.0f);
        return [NSString stringWithFormat:@"%.2fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024.0f);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
    
}


+ (NSString *)JudgePhoneNumber:(NSString *)phoneNum
{
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^134[0-8]\\d{7}$|^(?:13[5-9]|147|15[0-27-9]|178|1703|1705|1706|18[2-478])\\d{7,8}$";
    NSString * CU = @"^(?:13[0-2]|145|15[56]|176|1704|1707|1708|1709|171|18[56])\\d{7,8}|$";
    NSString * CT = @"^(?:133|153|1700|1701|1702|177|173|18[019])\\d{7,8}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestcm evaluateWithObject:phoneNum] == YES){
        //移动
        return @"中国移动";
    }else if ([regextestct evaluateWithObject:phoneNum] == YES){
        //电信
        return @"中国电信";
    }else if ([regextestcu evaluateWithObject:phoneNum] == YES){
        //联通
        return @"中国联通";
    }else{
        //可能还有未收录全的三大运营商号码，无法识别，后期会添加
        
        return @"位置运营商";
    }
}


@end
