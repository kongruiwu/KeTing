//
//  KrUuid.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/9/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "KrUuid.h"
#import <UIKit/UIKit.h>
@implementation KrUuid

static NSString * const KEY_IN_KEYCHAIN_UUID = @"KETING_UUID";
static NSString * const KEY_UUID = @"keting_uuid";

+ (NSString *)UUID{
    NSMutableDictionary * dic = (NSMutableDictionary *)[[KrUuid new] getKeychainQuery:KEY_IN_KEYCHAIN_UUID];
    NSString * str = [dic objectForKey:KEY_UUID];
    if (!str || str.length == 0) {
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        str = deviceUUID;
        [self saveUUID:deviceUUID];
    }
    return  str;
}
+ (void)saveUUID:(NSString *)uuid{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:uuid forKey:KEY_UUID];
    [[KrUuid new] save:KEY_IN_KEYCHAIN_UUID data:dic];
}

+ (void)deleteUUID{
    [[KrUuid new] delete:KEY_IN_KEYCHAIN_UUID];
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}
- (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}
- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}
- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
