//
//  HS2SProModule.m
//  ReactNativeIOSLibrary
//
//  Created by jing on 2018/11/26.
//  Copyright © 2018年 daiqingquan. All rights reserved.
//

#import "HS2SProModule.h"
#import "HS2SProProfileModule.h"
#import "HSMacroFile.h"
#import "HS2SPROController.h"
#import "HS2SPRO.h"
#import "iHealthDeviceManagerModule.h"
#import "ManageDeviceController.h"

#define EVENT_NOTIFY @"HS2SPro.MODULE.NOTIFY"
#define kMAC_KEY        @"mac"
#define kACTION_KEY     @"action"
#define kTYPE_KEY     @"type"

#define kTYPE_HS2SPRO     @"HS2S Pro"

@implementation HS2SProModule
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

#pragma mark-init

-(NSDictionary *)constantsToExport{
    return @{
             @"Event_Notify" :  EVENT_NOTIFY
             };
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

-(HS2SPRO *)getHS2SPROWithMac:(NSString *)mac{
    HS2SPROController *controller = [HS2SPROController shareIHHS2SPROController];
    NSArray *hs2sproDeviceArray = [controller getAllCurrentHS2SPROInstace];
    for (HS2SPRO *tempHS2SPRO in  hs2sproDeviceArray) {
        if ([mac isEqualToString:tempHS2SPRO.serialNumber]){
            return tempHS2SPRO;
            break;
        }
    }
    return nil;
}

#pragma mark
#pragma mark - Method


#pragma mark-获取连接设备
RCT_EXPORT_METHOD(getAllConnectedDevices){
    
    
    NSArray*hs2sProarray= [[HS2SPROController shareIHHS2SPROController] getAllCurrentHS2SPROInstace];
    
    NSMutableArray*deviceMacArray=[NSMutableArray array];
    
    for (int i=0; i<[hs2sProarray count]; i++) {
        
        HS2SPRO*hs2sPro=[hs2sProarray objectAtIndex:i];
        
        [deviceMacArray addObject:hs2sPro.serialNumber];
        
    }
    
    NSDictionary* deviceInfo = @{kACTION_KEY:ACTION_GET_ALL_CONNECTED_DEVICES,@"devices":deviceMacArray};
    [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
    
    
}

RCT_EXPORT_METHOD(getDeviceInfo:(nonnull NSString*)mac){
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        __weak typeof(self) weakSelf = self;
        
        [[self getHS2SPROWithMac:mac] commandGetHS2SPRODeviceInfo:^(NSDictionary * _Nonnull deviceInfo) {
            
            NSDictionary* deviceInfoDic = @{kMAC_KEY:mac,
                                            kTYPE_KEY:kTYPE_HS2SPRO,
                                            kACTION_KEY:ACTION_GET_HS2SPRO_DEVICE_INFO,
                                            HS2SPRO_DEVICE_BATTERY:[deviceInfo valueForKey:@"Battery"],
                                            HS2SPRO_DEVICE_UNIT:[deviceInfo valueForKey:@"Unit"],
                                            HS2SPRO_DEVICE_USER_COUNT:[deviceInfo valueForKey:@"UserCount"]
            };
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfoDic];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
            
        }];

    }
}

RCT_EXPORT_METHOD(getBattery:(nonnull NSString*)mac){
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        __weak typeof(self) weakSelf = self;
        
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROBattery:^(NSNumber * _Nonnull battary) {
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:BATTERY_HS,HS2SPRO_DEVICE_BATTERY:battary};
                       
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
}
RCT_EXPORT_METHOD(setUnit:(nonnull NSString*)mac :(nonnull NSNumber*)unit){
       
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        HSUnit tempUnit;
               
               switch ([unit intValue]) {
                   case 1:
                       tempUnit=HSUnit_Kg;
                       break;
                   case 2:
                       tempUnit=HSUnit_LB;
                       break;
                   case 3:
                       tempUnit=HSUnit_ST;
                       break;
                   default:
                        tempUnit=HSUnit_Kg;
                       break;
               }
        
        
        __weak typeof(self) weakSelf = self;
        
        [[self getHS2SPROWithMac:mac] commandSetHS2SPROUnit:tempUnit successBlock:^{
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                
            kMAC_KEY:mac,
            
            kTYPE_KEY:kTYPE_HS2SPRO,
            
            kACTION_KEY:ACTION_SET_HS2SPRO_UNIT,
            
            }];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

       

    }
    
}

RCT_EXPORT_METHOD(getUserInfo:(nonnull NSString*)mac){
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
          __weak typeof(self) weakSelf = self;
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROUserInfo:^(NSArray<HS2SProUser *> * _Nonnull array) {
            
            NSMutableArray*tempUserArray=[array copy];
            
            NSMutableArray*resultArray=[NSMutableArray array];
            
            
            if (tempUserArray>0) {
                
                for (int i=0; i<tempUserArray.count; i++) {
                    
                    HS2SProUser *user=[tempUserArray objectAtIndex:i];
                    
                     NSMutableDictionary*resultDic=[NSMutableDictionary dictionary];
                    
                    if(user.enableFitness==true){
                        
                        [resultDic setValue:@1 forKey:HS2SPRO_BODYBUILDING];
                        
                    }else{
                        
                        [resultDic setValue:@0 forKey:HS2SPRO_BODYBUILDING];
                    }
                    
                   
                    
                    if(user.enableMeasureImpedance==true){
                        
                        [resultDic setValue:@1 forKey:HS2SPRO_IMPEDANCE];
                    }else{
                        
                        [resultDic setValue:@0 forKey:HS2SPRO_IMPEDANCE];
                    }
           
                    [resultDic setValue:@(user.height) forKey:HS2SPRO_HEIGHT];
                    
                    [resultDic setValue:@(user.age) forKey:HS2SPRO_AGE];
                    
                    [resultDic setValue:@(user.gender) forKey:HS2SPRO_GENDER];
                    
                    [resultDic setValue:@(user.weight) forKey:HS2SPRO_WEIGTH];

                    
                    [resultDic setValue:@(user.createTS) forKey:HS2SPRO_CREATE_TIME];
                    
                    
                    NSString * userIDstr  =[[NSString alloc] initWithData:user.userId encoding:NSUTF8StringEncoding];
                    
                    [resultDic setValue:userIDstr forKey:HS2SPRO_USER_ID];
                    
                    [resultArray addObject:resultDic];
                    
                }
            }
            
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                
            kMAC_KEY:mac,
            
            kTYPE_KEY:kTYPE_HS2SPRO,
            
            kACTION_KEY:ACTION_GET_HS2SPRO_USER_INFO,
            
            HS2SPRO_USER_INFO_COUNT:@(array.count),
            
            HS2SPRO_USER_INFO_ARRAY:resultArray
            }];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
            
        }];
        
    }
}

RCT_EXPORT_METHOD(updateUserInfo:(nonnull NSString*)mac :(nonnull NSString*)userID :(nonnull NSNumber*)createTS :(nonnull NSNumber*)weight :(nonnull NSNumber*)age :(nonnull NSNumber*)height :(nonnull NSNumber*)sex :(nonnull NSNumber*)impedanceMark :(nonnull NSNumber*)fitnessMark){
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        
        if(userID.length!=16){
            
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
            [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            
            
            return;
        }
        
        
        HS2SProUser*user=[HS2SProUser new];
        
        NSData *data =[userID dataUsingEncoding:NSUTF8StringEncoding];
            
        user.userId=data;
            
        user.createTS=([createTS longLongValue]);
        
        user.weight=[weight doubleValue];
        
        user.age=[age intValue];
        
        user.height=[height intValue];
        
        if ([sex integerValue]==0) {
            
            user.gender=HS2SProGender_Female;
            
        }else{
            
           user.gender=HS2SProGender_Male;
        }
        
        if ([impedanceMark integerValue]==0) {
            
            user.enableMeasureImpedance=NO;
            
        }else{
            
           user.enableMeasureImpedance=YES;
        }
        
        if ([fitnessMark integerValue]==0) {
            
            user.enableFitness=NO;
            
        }else{
            
           user.enableFitness=YES;
        }
       
        __weak typeof(self) weakSelf = self;
        
        [[self getHS2SPROWithMac:mac] commandUpdateHS2SPROUserInfoWithUser:user successBlock:^{
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                           
                       kMAC_KEY:mac,
                       
                       kTYPE_KEY:kTYPE_HS2SPRO,
                       
                       kACTION_KEY:ACTION_UPDATE_HS2SPRO_USER_INFO,
                       
                       STATUS:@0
                       
                       }];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [self sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
    
}

RCT_EXPORT_METHOD(deleteUser:(nonnull NSString*)mac :(nonnull NSString*)userID){
    
    
    NSData *userIDData =[userID dataUsingEncoding:NSUTF8StringEncoding];
    
    
    __weak typeof(self) weakSelf = self;
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        if(userID.length!=16){
            
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
            [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            
            return;
        }
        
        [[self getHS2SPROWithMac:mac]commandDeleteHS2SPROUserWithUserId:userIDData successBlock:^{
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                      
                                  kMAC_KEY:mac,
                                  
                                  kTYPE_KEY:kTYPE_HS2SPRO,
                                  
                                  kACTION_KEY:ACTION_DELETE_HS2SPRO_USER,
                                  
                                  STATUS:@0
                                  
                                  }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
}

RCT_EXPORT_METHOD(getMemoryDataCount:(nonnull NSString*)mac :(nonnull NSString*)userID){
    
    
    NSData *userIDData =[userID dataUsingEncoding:NSUTF8StringEncoding];
    
     __weak typeof(self) weakSelf = self;
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        if(userID.length!=16){
            
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
            [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            
            
            return;
        }
        
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROMemoryDataCountWithUserId:userIDData successBlock:^(NSNumber * _Nonnull count) {
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                                 
                                             kMAC_KEY:mac,
                                             
                                             kTYPE_KEY:kTYPE_HS2SPRO,
                                             
                                             kACTION_KEY:ACTION_GET_HS2SPRO_MEMORY_COUNT,
                                             
                                             MEMORY_COUNT:count
                                             
                                             }];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

       

    }
}

RCT_EXPORT_METHOD(getMemoryData:(nonnull NSString*)mac :(nonnull NSString*)userID){
    
    
    NSData *userIDData =[userID dataUsingEncoding:NSUTF8StringEncoding];
    
     __weak typeof(self) weakSelf = self;
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        if(userID.length!=16){
            
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
            [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            
            
            return;
        }
        
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROMemoryDataWithUserId:userIDData successBlock:^(NSArray<HS2SProMeasurementModel *> * _Nonnull data) {
            NSMutableArray*resultArray=[NSMutableArray array];
            
            
            if (data>0) {
                
                for (int i=0; i<data.count; i++) {
                    
                    HS2SProMeasurementModel*dataModel=[data objectAtIndex:i];
                    
                     NSMutableDictionary*resultDic=[NSMutableDictionary dictionary];
                    
                    [resultDic setValue:@[@{HS2SPRO_IMPEDANCE:@(dataModel.impedance1)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance2)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance3)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance4)},] forKey:HS2SPRO_IMPEDANCE];
                    
                    [resultDic setValue:@(dataModel.loginId) forKey:HS2SPRO_USER_NUM];
                    
                    [resultDic setValue:@(dataModel.height) forKey:HS2SPRO_HEIGHT];
                    
                    [resultDic setValue:@(dataModel.age) forKey:HS2SPRO_AGE];
                    
                    [resultDic setValue:@(dataModel.gender) forKey:HS2SPRO_GENDER];
                    
                    [resultDic setValue:@(dataModel.weight) forKey:HS2SPRO_WEIGTH];
                    
                    [resultDic setValue:dataModel.dataId forKey:DATAID];
                    
                    if(dataModel.enableFitness==true){
                        
                        [resultDic setValue:@1 forKey:HS2SPRO_BODYBUILDING];
                    }else{
                        
                        [resultDic setValue:@0 forKey:HS2SPRO_BODYBUILDING];
                    }
                    
                    
                                                 
//                    NSDateFormatter *mydateFormatter = [[NSDateFormatter alloc] init];
//
//
//                    [mydateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//
//                    NSString *dateStr = [mydateFormatter stringFromDate:dataModel.measureTS];
//
//                    [resultDic setValue:dateStr forKey:HS2SPRO_MEASURE_TIME];
                    
                    
                    
                    [resultDic setValue:@([dataModel.measureTS timeIntervalSince1970]) forKey:HS2SPRO_MEASURE_TIME];
                    
                    if(dataModel.isRightTime==true){
                        
                        [resultDic setValue:@1 forKey:HS2SPRO_RIGHT_TIME];
                    }else{
                        
                        [resultDic setValue:@0 forKey:HS2SPRO_RIGHT_TIME];
                    }
                    
                    
                    
                    [resultDic setValue:@(dataModel.impedanceMeasureErrorCode) forKey:HS2SPRO_IMPEDANCE_ERROR];

                    
                    if(dataModel.muscle!=-1){
                      
                        [resultDic setValue:@(dataModel.muscle) forKey:HS2SPRO_MUSCLE_MASS];
                        [resultDic setValue:@(dataModel.bodyWaterPercentage) forKey:HS2SPRO_BODY_WATER_RATE];
                        
                        [resultDic setValue:@(dataModel.boneMineral) forKey:HS2SPRO_BONE_SALT_CONTENT];
                        
                        [resultDic setValue:@(dataModel.proteinPercentage) forKey:HS2SPRO_PROTEIN_RATE];
                        
                        [resultDic setValue:@(dataModel.bodyFatPercentage) forKey:HS2SPRO_BODY_FIT_PERCENTAGE];
                        [resultDic setValue:@1 forKey:HS2SPRO_INSTRUCTION_TYPE];
                        
                        [resultDic setValue:@(dataModel.encryptImpedance) forKey:HS2SPRO_IMPEDANCE_ENCRYPT];
                        
                    }else{
                        
                        [resultDic setValue:@0 forKey:HS2SPRO_INSTRUCTION_TYPE];
                    }

                    [resultArray addObject:resultDic];
                    
                }
            }
            
            
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                                            
                                                        kMAC_KEY:mac,
                                                        
                                                        kTYPE_KEY:kTYPE_HS2SPRO,
                                                        
                                                        kACTION_KEY:ACTION_GET_HS2SPRO_MEMORY_DATA,
                                                        
                                                        MEMORY_DATA:resultArray
                                                        
                                                        }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

    }
}

RCT_EXPORT_METHOD(deleteMemoryData:(nonnull NSString*)mac :(nonnull NSString*)userID){
    
    
    NSData *userIDData =[userID dataUsingEncoding:NSUTF8StringEncoding];
    
     __weak typeof(self) weakSelf = self;
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        if(userID.length!=16){
            
            NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
            [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            
            
            return;
        }
        
        [[self getHS2SPROWithMac:mac]commandDeleteHS2SPROMemoryDataWithUserId:userIDData successBlock:^{
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                                 
                                             kMAC_KEY:mac,
                                             
                                             kTYPE_KEY:kTYPE_HS2SPRO,
                                             
                                             kACTION_KEY:ACTION_DELETE_HS2SPRO_MEMORY_DATA,
                                             
                                             STATUS:@0
                                             
                                             }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

    }
}

RCT_EXPORT_METHOD(getAnonymousMemoryDataCount:(nonnull NSString*)mac){
    
    __weak typeof(self) weakSelf = self;
    
    if ([self getHS2SPROWithMac:mac] != nil) {
        
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROAnonymousMemoryDataCount:^(NSNumber * _Nonnull count) {
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                                            
                                                        kMAC_KEY:mac,
                                                        
                                                        kTYPE_KEY:kTYPE_HS2SPRO,
                                                        
                                                        kACTION_KEY:ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_COUNT,
                                                        
                                                        HS2SPRO_ANONYMOUSMEMORY_COUNT:count
                                                        
                                                        }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

    }
}

RCT_EXPORT_METHOD(getAnonymousMemoryData:(nonnull NSString*)mac){
    
    
     __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        [[self getHS2SPROWithMac:mac]commandGetHS2SPROAnonymousMemoryData:^(NSArray<HS2SProAnonymousModel *> * _Nonnull data) {
            NSMutableArray*resultArray=[NSMutableArray array];
                      
                      
                      if (data>0) {
                          
                          for (int i=0; i<data.count; i++) {
                              
                              HS2SProAnonymousModel*dataMode=[data objectAtIndex:i];
                              
                               NSMutableDictionary*resultDic=[NSMutableDictionary dictionary];
 
//                              NSDateFormatter *mydateFormatter = [[NSDateFormatter alloc] init];
//
//                              [mydateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//                              NSString *dateStr = [mydateFormatter stringFromDate:dataMode.measureTS];
                              
                              [resultDic setValue:@(dataMode.weight) forKey:HS2SPRO_WEIGTH];
                              
                              
//                              [resultDic setValue:dateStr forKey:HS2SPRO_MEASURE_TIME];
                              
                              [resultDic setValue:@([dataMode.measureTS timeIntervalSince1970]) forKey:HS2SPRO_MEASURE_TIME];
                              
                              [resultDic setValue:dataMode.dataId forKey:DATAID];
                              
                              if(dataMode.isRightTime==true){
                                  
                                  [resultDic setValue:@1 forKey:HS2SPRO_RIGHT_TIME];
                                  
                              }else{
                                  [resultDic setValue:@0 forKey:HS2SPRO_RIGHT_TIME];
                              }
                             

                              [resultArray addObject:resultDic];
                              
                          }
                      }
            
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                                                       
                                                                   kMAC_KEY:mac,
                                                                   
                                                                   kTYPE_KEY:kTYPE_HS2SPRO,
                                                                   
                                                                   kACTION_KEY:ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_DATA,
                                                                   
                                                                   MEMORY_DATA:resultArray
                                                                   
                                                                   }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];

    }
}

RCT_EXPORT_METHOD(deleteAnonymousMemoryData:(nonnull NSString*)mac){
    
    __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        [[self getHS2SPROWithMac:mac]commandDeleteHS2SPROAnonymousMemoryData:^{
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                
            kMAC_KEY:mac,
            
            kTYPE_KEY:kTYPE_HS2SPRO,
            
            kACTION_KEY:ACTION_DELETE_HS2SPRO_ANONYMOUS_MEMORY_DATA,
            
            STATUS:@0
            
            }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
}

RCT_EXPORT_METHOD(measure:(nonnull NSString*)mac :(nonnull NSNumber*)userType :(nonnull NSString*)userID :(nonnull NSNumber*)createTS :(nonnull NSNumber*)weight :(nonnull NSNumber*)age :(nonnull NSNumber*)height :(nonnull NSNumber*)sex :(nonnull NSNumber*)impedanceMark :(nonnull NSNumber*)fitnessMark){
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        __weak typeof(self) weakSelf = self;
        
        HS2SProUser*user=[HS2SProUser new];
    
        user.userId=[userID dataUsingEncoding:NSUTF8StringEncoding];
                   
        user.createTS=[createTS longLongValue];
        
        user.weight=[weight doubleValue];
        
        user.age=[age intValue];
        
        user.height=[height intValue];
        
        if ([sex integerValue]==0) {
            
            user.gender=HS2SProGender_Female;
            
        }else{
            
           user.gender=HS2SProGender_Male;
        }
        
        if ([impedanceMark integerValue]==0) {
            
            user.enableMeasureImpedance=NO;
            
        }else{
            
           user.enableMeasureImpedance=YES;
        }
        
        if ([fitnessMark integerValue]==0) {
            
            user.enableFitness=NO;
            
        }else{
            
           user.enableFitness=YES;
        }
        
        if([userType intValue]==1){
            
            if(userID.length!=16){
                
                NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:@"Error,the length of ID must be 32."};
                [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
                
                
                return;
            }
            
            
            [[self getHS2SPROWithMac:mac]commandStartHS2SPROMeasureWithUser:user realtimeWeightBlock:^(NSNumber * _Nonnull unStableWeight) {
                NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_HS2SPRO_ONLINE_DATA,HS2SPRO_WEIGTH:unStableWeight};
               [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
            } stableWeightBlock:^(NSNumber * _Nonnull stableWeight) {
                NSDictionary *deviceInfo =@{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_HS2SPRO_ONLINE_RESULT,HS2SPRO_WEIGTH:stableWeight,STATUS:@0};
            
               [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
               
            } weightAndBodyInfoBlock:^(NSDictionary * _Nonnull weightAndBodyInfoDic) {
                
                
                HS2SProMeasurementModel*dataModel=[weightAndBodyInfoDic valueForKey:@"Result"];
                
                
                NSMutableDictionary*resultDic=[NSMutableDictionary dictionary];
                
                if(dataModel.enableFitness==true){
                    
                    [resultDic setValue:@1 forKey:HS2SPRO_BODYBUILDING];
                }else{
                    
                    [resultDic setValue:@0 forKey:HS2SPRO_BODYBUILDING];
                }
                
                [resultDic setValue:@[@{HS2SPRO_IMPEDANCE:@(dataModel.impedance1)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance2)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance3)},@{HS2SPRO_IMPEDANCE:@(dataModel.impedance4)},] forKey:HS2SPRO_IMPEDANCE];
                
                
                [resultDic setValue:@(dataModel.loginId) forKey:HS2SPRO_USER_NUM];
                
                [resultDic setValue:@(dataModel.height) forKey:HS2SPRO_HEIGHT];
                
                [resultDic setValue:@(dataModel.age) forKey:HS2SPRO_AGE];
                
                [resultDic setValue:@(dataModel.gender) forKey:HS2SPRO_GENDER];
                
                
                 [resultDic setValue:@(dataModel.weight) forKey:HS2SPRO_WEIGTH];
                
                                             
//                NSDateFormatter *mydateFormatter = [[NSDateFormatter alloc] init];
//
//
//                [mydateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//
//                NSString *dateStr = [mydateFormatter stringFromDate:dataModel.measureTS];
                
//                [resultDic setValue:dateStr forKey:HS2SPRO_MEASURE_TIME];
                
                NSTimeInterval ts=[dataModel.measureTS timeIntervalSince1970];
                
                [resultDic setValue:[NSNumber numberWithInt:ts] forKey:HS2SPRO_MEASURE_TIME];
                
                [resultDic setValue:dataModel.dataId forKey:DATAID];
                
                if(dataModel.isRightTime==true){
                    
                    [resultDic setValue:@1 forKey:HS2SPRO_RIGHT_TIME];
                    
                }else{
                    [resultDic setValue:@0 forKey:HS2SPRO_RIGHT_TIME];
                }
                
                [resultDic setValue:@(dataModel.impedanceMeasureErrorCode) forKey:HS2SPRO_IMPEDANCE_ERROR];
          

                if(dataModel.muscle!=-1){
                  
                    [resultDic setValue:@(dataModel.muscle) forKey:HS2SPRO_MUSCLE_MASS];
                    [resultDic setValue:@(dataModel.bodyWaterPercentage) forKey:HS2SPRO_BODY_WATER_RATE];
                    
                    [resultDic setValue:@(dataModel.boneMineral) forKey:HS2SPRO_BONE_SALT_CONTENT];
                    
                    [resultDic setValue:@(dataModel.proteinPercentage) forKey:HS2SPRO_PROTEIN_RATE];
                    
                    [resultDic setValue:@(dataModel.bodyFatPercentage) forKey:HS2SPRO_BODY_FIT_PERCENTAGE];
                    [resultDic setValue:@1 forKey:HS2SPRO_INSTRUCTION_TYPE];
                    
                    [resultDic setValue:@(dataModel.encryptImpedance) forKey:HS2SPRO_IMPEDANCE_ENCRYPT];
                    
                }else{
                    
                    [resultDic setValue:@0 forKey:HS2SPRO_INSTRUCTION_TYPE];
                }
                    
                                       
                    
                    NSDictionary *deviceInfo =@{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_HS2SPRO_BODYFAT_RESULT,HS2SPRO_DATA_BODY_FAT_RESULT:resultDic };
                    
                       [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
                    
            } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
                [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
            }];
            
            
        }else{
         
            
            [[self getHS2SPROWithMac:mac]commandStartHS2SPROGuestMeasureWithRealtimeWeightBlock:^(NSNumber * _Nonnull unStableWeight) {
                
                NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_HS2SPRO_ONLINE_DATA,HS2SPRO_WEIGTH:unStableWeight};
               [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
                
            } stableWeightBlock:^(NSNumber * _Nonnull stableWeight) {
                
                NSDictionary *deviceInfo =@{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_HS2SPRO_ONLINE_RESULT,HS2SPRO_WEIGTH:stableWeight,STATUS:@0};
            
               [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
                
            } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
                
                [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
            }];
            
            
        }
              
       

    }
}


RCT_EXPORT_METHOD(resetDevice:(nonnull NSString*)mac){
    
    
    __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        [[self getHS2SPROWithMac:mac]commandResetHS2SPRODevice:^{
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                
            kMAC_KEY:mac,
            
            kTYPE_KEY:kTYPE_HS2SPRO,
            
            kACTION_KEY:ACTION_HS2SPRO_RESET_DEVICE,
            
            STATUS:@0
            
            }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
}

//RCT_EXPORT_METHOD(broadCastTypeDevice:(nonnull NSString*)mac){
//
//
//    __weak typeof(self) weakSelf = self;
//
//
//    if ([self getHS2SPROWithMac:mac] != nil) {
//
//        [[self getHS2SPROWithMac:mac]commandBroadCastTypeHS2SDevice:^(BOOL result) {
//
//            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
//
//            kMAC_KEY:mac,
//
//            kTYPE_KEY:kTYPE_HS2SPRO,
//
//            kACTION_KEY:ACTION_BroadCastType_DEVICE,
//
//            HS2SPRO_SET_RESULT:[NSNumber numberWithBool:result]
//
//            }];
//
//        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
//
//             [self sendHS2SPROErrorCode:errorID mac:mac];
//
//        }];
//
//    }
//}


RCT_EXPORT_METHOD(setDeviceLightUp:(nonnull NSString*)mac){
    
    
    __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        [[self getHS2SPROWithMac:mac] commandShowBluetoothLightWithSuccessBlock:^{
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                          
                      kMAC_KEY:mac,
                      
                      kTYPE_KEY:kTYPE_HS2SPRO,
                      
                      kACTION_KEY:ACTION_HS2SPRO_LightUp_DEVICE,
                    
                      
                      }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];
        


    }
}


RCT_EXPORT_METHOD(enterHS2SProHeartRateMeasurementMode:(nonnull NSString*)mac){
    
    
    __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        
        
        [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                  
                              kMAC_KEY:mac,
                              
                              kTYPE_KEY:kTYPE_HS2SPRO,
                              
                              kACTION_KEY:ACTION_HS2SPRO_START_MEASURE_HEARTRATE,
                              
                              STATUS:@0
                              
                              }];
        
        
        [[self getHS2SPROWithMac:mac] commandEnterHS2SPROHeartRateMeasurementMode:^(NSDictionary * _Nonnull heartResultDic) {
            
            int result = [heartResultDic[@"HS2SProNotiKey_MeasureSuccessFlag"] intValue];
            
            if(result==0){
                
                [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                    
                    kMAC_KEY:mac,
                    
                    kTYPE_KEY:kTYPE_HS2SPRO,
                    
                    kACTION_KEY:ACTION_HS2SPRO_MEASURE_RESULT,
                    
                    HS2SPRO_HEARTRATE:[heartResultDic valueForKey:@"HS2SProNotiKeyHeartRate"]
                    
                }];
            }else{
                
                
                [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                    
                    kMAC_KEY:mac,
                    
                    kTYPE_KEY:kTYPE_HS2SPRO,
                    
                    kACTION_KEY:ACTION_HS2SPRO_MEASURE_HEARTRATE_FAIL,
                    
                    
                }];
                
            }
        } measurementStatus:^(NSNumber * _Nonnull measurementStatus) {
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                                      
                                  kMAC_KEY:mac,
                                  
                                  kTYPE_KEY:kTYPE_HS2SPRO,
                                  
                                  kACTION_KEY:ACTION_HS2SPRO_MEASURE_HEARTRATE_DEVICE_STATUS,
                                  
                                  STATUS:measurementStatus
                                  
                                  }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];


    }
}


RCT_EXPORT_METHOD(exitHS2SProHeartRateMeasurementMode:(nonnull NSString*)mac){
    
    
    __weak typeof(self) weakSelf = self;
    

    if ([self getHS2SPROWithMac:mac] != nil) {
        [[self getHS2SPROWithMac:mac] commandExitHS2SPROHeartRateMeasurementMode:^{
            
            [weakSelf.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{
                
            kMAC_KEY:mac,
            
            kTYPE_KEY:kTYPE_HS2SPRO,
            
            kACTION_KEY:ACTION_HS2SPRO_EXIT_MEASURE_HEARTRATE_STATUS,
            
            STATUS:@0
            
            }];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf sendHS2SPROErrorCode:errorID mac:mac];
        }];
        


    }
}




-(void)sendHS2SPROErrorCode:(HS2SPRODeviceError)errorID mac:(NSString*)mac{
    
    
                NSString *errorMassage = [NSString string];
                switch (errorID) {
                    case 0:
                         errorMassage = @"Communication Timeout";
                        break;
                    case 1:
                        errorMassage = @"Received CommandError";
                        break;
                    case 2:
                         errorMassage = @"Input ParameterError";
                        break;
                    case 3:
                        errorMassage = @"More Than Max Numbers Of User";
                        break;
                    case 4:
                        errorMassage = @"Write Flash Error";
                        break;
                    case 5:
                         errorMassage = @"User Not Exist";
                        break;
                    case 6:
                        errorMassage = @"Start Measure Error";
                        break;
                    case 7:
                        errorMassage = @"Measure Timeout";
                        break;
                    case 8:
                       errorMassage = @"Measure Over weight";
                        break;
                    case 9:
                       errorMassage = @"Measure Not Get Stable Weight";
                        break;
                        
                    case 10:
                        errorMassage = @"Disconnect";
                        break;
                    case 11:
                        errorMassage = @"Unsupported";
                       break;

                    default:
                        break;
                }
    
                NSDictionary *deviceInfo = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_HS2SPRO,kACTION_KEY:ACTION_ERROR_HS,ERROR_DESCRIPTION_HS:errorMassage};
                [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
    
    
}

RCT_EXPORT_METHOD(disconnect:(nonnull NSString*)mac){
    if ([self getHS2SPROWithMac:mac] != nil){
        
        [[self getHS2SPROWithMac:mac]commandDisconnectDevice];
        NSLog(@"End device connnect!");
        
    }else{
        
    }
}


- (void)sendEventWithAction:(NSString*)actionName keyString:(NSString*)key valueString:(id)value{
    [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:@{kACTION_KEY:actionName,key:value}];
}

@end

