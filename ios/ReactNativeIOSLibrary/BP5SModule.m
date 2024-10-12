//
//  BP5SModule.m
//  ReactNativeIOSLibrary
//
//  Created by soso on 2019/4/17.
//  Copyright © 2019 daiqingquan. All rights reserved.
//

#import "BP5SModule.h"

#import "BPProfileModule.h"
#import "BPMacroFile.h"
#import "BP5SController.h"
#import "BP5S.h"
#import "iHealthDeviceManagerModule.h"

#import "ScanDeviceController.h"
#import "ConnectDeviceController.h"
#define EVENT_NOTIFY @"BP5S.MODULE.NOTIFY"

#define kMAC_KEY        @"mac"
#define kACTION_KEY     @"action"
#define kTYPE_KEY     @"type"

#define kTYPE_BP5S     @"BP5S"

@interface BP5SModule ()
@property (nonatomic, assign) BOOL isMeasuring;

@property (nonatomic, copy) NSNumber* bpPr;

@end


@implementation BP5SModule
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
    return @{
             @"Event_Notify":EVENT_NOTIFY,
             
             };
}
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

-(BP5S*)getDeviceWithMac:(NSString*)mac{
    
    BP5SController *controller = [BP5SController sharedController];
    NSArray *bpDeviceArray = [controller getAllCurrentInstance];
    
    for(BP5S *tempDevice in bpDeviceArray){
        if([mac isEqualToString:tempDevice.serialNumber]){
            
            return tempDevice;
        }
    }
    
    return nil;
}


#pragma mark - Method


#pragma mark-获取连接设备
RCT_EXPORT_METHOD(getAllConnectedDevices){
    
    
    NSArray *bp5sArray= [[BP5SController sharedController] getAllCurrentInstance];
    
    NSMutableArray *deviceMacArray = [NSMutableArray array];
    
    for (int i=0; i<[bp5sArray count]; i++) {
        
        BP5S *bp5s=[bp5sArray objectAtIndex:i];
        
        [deviceMacArray addObject:bp5s.serialNumber];
        
    }
    
    NSDictionary* deviceInfo = @{kACTION_KEY:@"action_get_all_connected_devices",@"devices":deviceMacArray};
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:EVENT_NOTIFY body:deviceInfo];
    
}


//开始测量
RCT_EXPORT_METHOD(startMeasure:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
        
        [[self getDeviceWithMac:mac] commandStartMeasureWithZeroingState:^(BOOL isComplete) {
            weakSelf.isMeasuring = YES;
            NSDictionary* response = @{
							kMAC_KEY:mac,kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:isComplete ? kACTION_ZOREOVER_BP : kACTION_ZOREING_BP,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } pressure:^(NSArray *pressureArr) {
            weakSelf.isMeasuring = YES;
					
					weakSelf.bpPr=pressureArr.firstObject;
            
            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_ONLINE_PRESSURE_BP,
                                       kBLOOD_PRESSURE_BP:weakSelf.bpPr,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } waveletWithHeartbeat:^(NSArray *waveletArr) {
            weakSelf.isMeasuring = YES;

            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_ONLINE_PULSEWAVE_BP,
                                       kFLAG_HEARTBEAT_BP:@(1),
                                       kPULSEWAVE_BP:waveletArr,
																			 kBLOOD_PRESSURE_BP:weakSelf.bpPr,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } waveletWithoutHeartbeat:^(NSArray *waveletArr) {
            weakSelf.isMeasuring = YES;

            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_ONLINE_PULSEWAVE_BP,
                                       kFLAG_HEARTBEAT_BP:@(0),
                                       kPULSEWAVE_BP:waveletArr,
																			 kBLOOD_PRESSURE_BP:weakSelf.bpPr,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } result:^(NSDictionary *resultDict) {
            weakSelf.isMeasuring = NO;
	
            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_ONLINE_RESULT_BP,
                                       kHIGH_BLOOD_PRESSURE_BP:resultDict[@"sys"],
                                       kLOW_BLOOD_PRESSURE_BP:resultDict[@"dia"],
                                       kPULSE_BP:resultDict[@"heartRate"],
                                       kMEASUREMENT_AHR_BP:resultDict[@"irregular"],
                                       kDATAID:resultDict[@"dataID"],
																			 kMEASUREMENT_HSD_BP:resultDict[@"hsdValue"],
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } errorBlock:^(BPDeviceError error) {
            weakSelf.isMeasuring = NO;
            NSLog(@"error %lu",(unsigned long)error);
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
        }];
        
    }else{
        self.isMeasuring = NO;
        NSLog(@"error %lu",(unsigned long)BPDidDisconnect);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}

//停止测量
RCT_EXPORT_METHOD(stopMeasure:(nonnull NSString *)mac){
    if (!self.isMeasuring) {
        NSLog(@"error %d",401);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:401];
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([self getDeviceWithMac:mac]!=nil) {
        [[self getDeviceWithMac:mac] stopBPMeassureSuccessBlock:^{
            
            weakSelf.isMeasuring = NO;
            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_INTERRUPTED_BP,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
            
        } errorBlock:^(BPDeviceError error) {
            
            NSLog(@"error %lu",(unsigned long)error);
            weakSelf.isMeasuring = NO;
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
        }];
        
        
    }else{
        weakSelf.isMeasuring = NO;
        NSLog(@"error %lu",(unsigned long)BPDidDisconnect);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
    
    
}

//删除功能
RCT_EXPORT_METHOD(deleteData:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
        [[self getDeviceWithMac:mac] commandDeleteDataSuccessBlock:^{
            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_Delete_BP5S,
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
        } errorBlock:^(BPDeviceError error) {
            NSLog(@"error %lu",(unsigned long)error);
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
        }];
    }else{
        NSLog(@"error %lu",(unsigned long)BPDidDisconnect);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}

//set offline
RCT_EXPORT_METHOD(enbleOffline:(nonnull NSString *)mac mode:(nonnull NSNumber *)mode){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __block BOOL success = YES;
        __weak typeof(self) weakSelf = self;
        
        BOOL flag;
        
        if ([mode boolValue] == YES) {
            flag = YES;
        }else{
            flag = NO;
        }
        
        [[self getDeviceWithMac:mac] commandSetOffline:flag success:^{
            
                NSDictionary* response = @{
                                           kMAC_KEY:mac,
																					 kTYPE_KEY:kTYPE_BP5S,
                                           kACTION:kACTION_SET_MODE,
                                           };
                [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
            
        } error:^(BPDeviceError error) {
            success = NO;
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
        }];
    }else{
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}


//get battery
RCT_EXPORT_METHOD(getBattery:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
			
			[[self getDeviceWithMac:mac] commandEnergy:^(NSNumber *energyValue) {
				NSDictionary* response = @{
																	 kMAC_KEY:mac,
																	 kTYPE_KEY:kTYPE_BP5S,
																	 kACTION:kACTION_BATTERY_BP,
																	 kBATTERY_BP:energyValue,
																	 @"batteryStatus":@1
																	 };
				[BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
			} energyState:^(NSNumber *energyState) {
				
				
			} errorBlock:^(BPDeviceError error) {
				NSLog(@"error %lu",(unsigned long)error);
				[BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
			}];
        
    }else{
        NSLog(@"error %lu",(unsigned long)BPDidDisconnect);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}

//get history number
RCT_EXPORT_METHOD(getOffLineNum:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
        [[self getDeviceWithMac:mac]commandTransferMemoryTotalCount:^(NSNumber *num) {
            
            NSDictionary* response = @{
                                       kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
                                       kACTION:kACTION_HISTORICAL_NUM_BP,
                                       kHISTORICAL_NUM_BP:num
                                       };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
            
        } errorBlock:^(BPDeviceError error) {
            
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
            
        }];
        
    }else{
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}


//get history data
RCT_EXPORT_METHOD(getOffLineData:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
        
        [[self getDeviceWithMac:mac] commandTransferMemoryDataWithTotalCount:^(NSNumber *count) {
					
					
            if ([count integerValue] == 0) {
							
							NSDictionary* response = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_BP5S,kACTION:kACTION_HISTORICAL_DATA_BP };
							[BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
							
                NSDictionary* response1 = @{kMAC_KEY:mac,kTYPE_KEY:kTYPE_BP5S,kACTION:kACTION_GETHISTORY_OVER_BP };
                [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response1];
						}
        } progress:^(NSNumber *progress) {
            
        } dataArray:^(NSArray *array) {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            
            for(NSDictionary *history in array)
            {
                
                NSNumber *dateNum = [history objectForKey:@"time"];

                NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:[dateNum integerValue]];                
               
                NSDateFormatter *mydateFormatter = [[NSDateFormatter alloc] init];
                [mydateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateStr = [mydateFormatter stringFromDate:tempDate];
                
                NSNumber*bpHSD=[history valueForKey:@"hsdValue"];
							
							  NSNumber*isRightTime=[history valueForKey:@"isRightTime"];
							
							NSMutableDictionary *dic=[NSMutableDictionary dictionary];
							
							
							[dic setValue:mac forKey:kMAC_KEY];
							[dic setValue:dateStr forKey:kMEASUREMENT_TIME_BP];
							[dic setValue:[history objectForKey:@"dia"] forKey:kLOW_BLOOD_PRESSURE_BP];
							[dic setValue:[history objectForKey:@"sys"] forKey:kHIGH_BLOOD_PRESSURE_BP];
							[dic setValue:[history objectForKey:@"irregular"] forKey:kMEASUREMENT_IHB_BP5S];
							[dic setValue:[history objectForKey:@"heartRate"] forKey:kPULSE_BP];
							[dic setValue:[history objectForKey:@"dataID"] forKey:kDATAID];
							
							[dic setValue:@0 forKey:@"body_movement"];
									
							
							
							if (bpHSD!=nil) {
							
								[dic setValue:history[@"hsdValue"] forKey:kMEASUREMENT_HSD_BP5S];
							}else{
								
								[dic setValue:@0 forKey:kMEASUREMENT_HSD_BP5S];
							}
							
							if (isRightTime!=nil) {
								[dic setValue:isRightTime forKey:kTIME_Right];
							}
							
                [tempArr addObject:dic];
            }
            
            if (tempArr.count > 0) {
                NSDictionary* response = @{
                                           kMAC_KEY:mac,
																					 kTYPE_KEY:kTYPE_BP5S,
                                           kACTION:kACTION_HISTORICAL_DATA_BP,
                                           kHISTORICAL_DATA_BP:[tempArr copy]
                                           };
                [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
            }
            
        } errorBlock:^(BPDeviceError error) {
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
        }];
        
    }else{
        
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
    
    
}

//function
RCT_EXPORT_METHOD(getFunctionInfo:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
        [[self getDeviceWithMac:mac] commandFunction:^(NSDictionary *dic) {

					
					if ([dic objectForKey:@"deviceSysTime"]!=nil && [dic objectForKey:@"deviceTime"]!=nil) {
						
						NSDictionary* response = @{
																			 kMAC_KEY:mac,
																			 kTYPE_KEY:kTYPE_BP5S,
																			 kACTION:kACTION_FUNCTION_INFORMATION_BP,
																			 kFUNCTION_IS_UPAIR_MEASURE: [dic objectForKey:@"upAirMeasureFlg"],
																			 kFUNCTION_IS_ARM_MEASURE: [dic objectForKey:@"armMeasureFlg"],
																			 kFUNCTION_HAVE_OFFLINE: [dic objectForKey:@"haveOffline"],
																			 kFUNCTION_HAVE_HSD: [dic objectForKey:@"haveHSD"],
																			 kFUNCTION_DEVICE_TIME: [dic objectForKey: @"deviceTime"],
																			 kFUNCTION_DEVICE_SYSTIME: [dic objectForKey: @"deviceSysTime"],
																			 @"function_max_memory_capacity": [dic objectForKey: @"maxHistoryCount"],
						                           @"function_have_power_off": [dic objectForKey: @"havePowerOff"],
																			 @"function_reconnect_open": [dic objectForKey: @"autoConnect"],
																			 @"function_have_show_unit_setting": [dic objectForKey: @"hasUnitSetting"],
																			 @"function_show_unit": [dic objectForKey: @"unitKPa"],
																			 @"function_have_body_movement": [dic objectForKey: @"hasMoveDetect"],
																			 @"function_user_can_delete_memory": [dic objectForKey: @"haveClearMemory"],
																			 @"function_have_measure_offline": [dic objectForKey: @"offlineMeasureFlg"],
																			 @"function_measure_offline_open": [dic objectForKey: @"offlineSetingFlg"],
																			 @"function_bluetooth_open_mode": [dic objectForKey: @"btfunctionFlg"],
																			 @"function_limbs_Simultaneous_MeasureFlg": [dic objectForKey: @"autoLoopMeasureModel"],
																			 @"function_have_reconnect_setting": [dic objectForKey: @"reConnectSwitch"],
																			 @"function_if_abi_machine": @0,
																			 kFUNCTION_HAVE_ANGLE_SENSOR:[dic objectForKey: @"haveAngleSensor"],
																			 @"function_memory_group": @1,
																			 @"function_lower_or_upper_machine":@0,
																			 @"function_right_or_left_limb_machine":@0,
																			 @"function_operating_state":@0,
																			 };
						[BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
						
					}else{
						
						NSDictionary* response = @{
							kMAC_KEY:mac,
							kTYPE_KEY:kTYPE_BP5S,
							kACTION:kACTION_FUNCTION_INFORMATION_BP,
							kFUNCTION_IS_UPAIR_MEASURE: [dic objectForKey:@"upAirMeasureFlg"],
							kFUNCTION_IS_ARM_MEASURE: [dic objectForKey:@"armMeasureFlg"],
							kFUNCTION_HAVE_OFFLINE: [dic objectForKey:@"haveOffline"],
							kFUNCTION_HAVE_HSD: [dic objectForKey:@"haveHSD"],
							@"function_max_memory_capacity": [dic objectForKey: @"maxHistoryCount"],
							@"function_have_power_off": [dic objectForKey: @"havePowerOff"],
							@"function_reconnect_open": [dic objectForKey: @"autoConnect"],
							@"function_have_show_unit_setting": [dic objectForKey: @"hasUnitSetting"],
							@"function_show_unit": [dic objectForKey: @"unitKPa"],
							@"function_have_body_movement": [dic objectForKey: @"hasMoveDetect"],
							@"function_user_can_delete_memory": [dic objectForKey: @"haveClearMemory"],
							@"function_have_measure_offline": [dic objectForKey: @"offlineMeasureFlg"],
							@"function_measure_offline_open": [dic objectForKey: @"offlineSetingFlg"],
							@"function_bluetooth_open_mode": [dic objectForKey: @"btfunctionFlg"],
							@"function_limbs_Simultaneous_MeasureFlg": [dic objectForKey: @"autoLoopMeasureModel"],
							@"function_have_reconnect_setting": [dic objectForKey: @"reConnectSwitch"],
							@"function_if_abi_machine": @0,
							kFUNCTION_HAVE_ANGLE_SENSOR:[dic objectForKey: @"haveAngleSensor"],
							@"function_memory_group": @1,
							@"function_lower_or_upper_machine":@0,
							@"function_right_or_left_limb_machine":@0,
							@"function_operating_state":@0,
						};
						[BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
						
						
					}
            
           
            
        } errorBlock:^(BPDeviceError error) {
            
            [BPProfileModule sendErrorToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithCode:error];
            
        }];
    }else{
        
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}

//disconnect
RCT_EXPORT_METHOD(disconnect:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        [[self getDeviceWithMac:mac] commandDisconnectDevice];
    }else{
        NSLog(@"error %lu",(unsigned long)BPDidDisconnect);
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect];
    }
}

#pragma mark - Method

RCT_EXPORT_METHOD(getHardwareVersion:(nonnull NSString *)mac){
    
    if ([self getDeviceWithMac:mac]!=nil) {
        __weak typeof(self) weakSelf = self;
       
        BP5S*device=[self getDeviceWithMac:mac];
            NSDictionary* response = @{
                kACTION:kACTION_GET_HARDWARE_VERSION,
                kHARDWARE_VERSION: device.hardwareVersion,
								kTYPE_KEY:kTYPE_BP5S,
                kMAC:mac
            };
            [BPProfileModule sendEventToBridge:weakSelf.bridge eventNotify:EVENT_NOTIFY WithDict:response];
            
       
    }else{
        
        [BPProfileModule sendErrorToBridge:self.bridge eventNotify:EVENT_NOTIFY WithCode:BPDidDisconnect mac:mac type:kTYPE_BP5S];
        
    }
    
    
}

@end
