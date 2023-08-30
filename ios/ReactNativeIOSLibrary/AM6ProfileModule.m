//
//  AM6ProfileModule.m
//  ReactNativeIOSLibrary
//
//  Created by Spring on 2023/8/28.
//

#import "AM6ProfileModule.h"
#import "AMMacroFile.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <zlib.h>


@implementation AM6ProfileModule


RCT_EXPORT_MODULE()

#pragma mark
#pragma mark - constantsToExport


- (NSDictionary *)constantsToExport
{
    return @{
             AM6_ACTION:AM6_ACTION,
             AM6_DEVICE:AM6_DEVICE,
             AM6_KEY_MAC:AM6_KEY_MAC,
             AM6_TYPE:AM6_TYPE,
             
             @"ACTION_GET_ALL_CONNECTED_DEVICES":kACTION_GET_ALL_CONNECTED_DEVICES,
            
             };
};


+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

+ (NSString*)descriptionForErrorCode:(NSInteger)errorCode{
    switch (errorCode) {
        case 0:
            return @"not find a suitable zero in 20s.";
        case AM6DeviceError_InputParameterError:
            return @"Parameters out of range.";
        case 404:
            return @"iOS does not support this API";
        case 900:
            return @"iOS doesn't support disconnect normal BT devices";
    }
    return @"unknown error";
}

+ (void)sendErrorToBridge:(RCTBridge *)bridge eventNotify:(NSString*)eventNotify WithCode:(NSInteger)errorCode{
    NSDictionary*  errorDict;
    
    
    if(errorCode==AM6DeviceError_DeviceDisconnect || errorCode==AM6DeviceConnectError_Disconnect){
        
    
        errorDict = @{
            AM6_ACTION:ACTION_ERROR_AM6,
            ERROR_DESCRIPTION_AM6:[self descriptionForErrorCode:errorCode]
                      };
    
    }else{
        
        
       errorDict = @{
           AM6_ACTION:ACTION_ERROR_AM6,
           ERROR_NUM_AM6:@(errorCode),
           ERROR_DESCRIPTION_AM6:[self descriptionForErrorCode:errorCode]
            };

    
    }
    
    [self sendEventToBridge:bridge eventNotify:eventNotify WithDict:errorDict];
}

+ (void)sendEventToBridge:(RCTBridge *)bridge eventNotify:(NSString*)eventNotify WithDict:(NSDictionary*)dict{
    [bridge.eventDispatcher sendDeviceEventWithName:eventNotify body:dict];
}


+ (NSData *)md5:(NSString *)hashString{
    
    NSData *data = [hashString dataUsingEncoding:NSUTF8StringEncoding];
    // 计算md5
    unsigned char *digest;
    digest = (unsigned char *)malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSData *md5Data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return md5Data;
}

+(void)sendNoDevice:(RCTBridge *)bridge{
    
    
    NSDictionary* deviceInfo = @{AM6_ACTION:ACTION_ERROR_AM6,ERROR_DESCRIPTION_AM6:ACTION_DISCONNECT_AM6};
    [bridge.eventDispatcher sendDeviceEventWithName:AM6_EVENT_NOTIFY body:deviceInfo];
    
}


@end
