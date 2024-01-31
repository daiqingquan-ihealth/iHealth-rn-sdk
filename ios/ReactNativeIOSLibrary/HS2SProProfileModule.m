//
//  HSProfileModule.m
//  ReactNativeIOSLibrary
//
//  Created by ihealth on 16/12/2.
//  Copyright © 2016年 daiqingquan. All rights reserved.
//

#import "HS2SProProfileModule.h"

@implementation HS2SProProfileModule

RCT_EXPORT_MODULE()

#pragma mark
#pragma mark - constantsToExport
@synthesize bridge = _bridge;

-(NSDictionary *)constantsToExport{
    return @{
             @"ACTION_LIVEDATA_HS" : ACTION_LIVEDATA_HS,
             @"LIVEDATA_HS" : LIVEDATA_HS,
             
             @"ACTION_ONLINE_RESULT_HS" : ACTION_ONLINE_RESULT_HS,
             @"DATAID" : DATAID,
             @"WEIGHT_HS" : WEIGHT_HS,
             @"FAT_HS" : FAT_HS,
             @"WATER_HS" : WATER_HS,
             @"MUSCLE_HS" : MUSCLE_HS,
             @"SKELETON_HS" : SKELETON_HS,
             @"FATELEVEL_HS" : FATELEVEL_HS,
             @"DCI_HS" : DCI_HS,
             @"STATUS":STATUS,
             
             @"ACTION_HISTORICAL_DATA_HS" : ACTION_HISTORICAL_DATA_HS,
             @"HISTORDATA_HS" :HISTORDATA_HS,
             @"MEASUREMENT_DATE_HS" : MEASUREMENT_DATE_HS,
             @"ACTION_HISTORICAL_DATA_COMPLETE_HS" :ACTION_HISTORICAL_DATA_COMPLETE_HS,
             @"ACTION_NO_HISTORICALDATA" : ACTION_NO_HISTORICALDATA,
             
             @"ACTION_ERROR_HS" : ACTION_ERROR_HS,
             @"ERROR_NUM_HS" : ERROR_NUM_HS,
             @"ERROR_ID_ILLEGAL_ARGUMENT" : ERROR_ID_ILLEGAL_ARGUMENT,
             @"ERROR_ID_WIFI_DISABLED" : ERROR_ID_WIFI_DISABLED,
             @"ERROR_DESCRIPTION_HS" : ERROR_DESCRIPTION_HS,
             
             @"ACTION_GET_ALL_CONNECTED_DEVICES":ACTION_GET_ALL_CONNECTED_DEVICES,
             
             @"ACTION_BATTERY_HS":ACTION_BATTARY_HS,
             @"BATTERY_HS":BATTERY_HS,
             
             @"ACTION_GET_HS2SPRO_DEVICE_INFO":ACTION_GET_HS2SPRO_DEVICE_INFO,
             
             @"ACTION_SET_HS2SPRO_UNIT":ACTION_SET_HS2SPRO_UNIT,
             
             @"HS2SPRO_DEVICE_INFO":HS2SPRO_DEVICE_INFO,
             
             @"ACTION_GET_HS2SPRO_USER_INFO":ACTION_GET_HS2SPRO_USER_INFO,
             
             @"HS2SPRO_USER_INFO_ARRAY":HS2SPRO_USER_INFO_ARRAY,
             
             @"HS2SPRO_USER_INFO_COUNT":HS2SPRO_USER_INFO_COUNT,
             
             @"ACTION_UPDATE_HS2SPRO_USER_INFO":ACTION_UPDATE_HS2SPRO_USER_INFO,
             
             @"ACTION_DELETE_HS2SPRO_USER":ACTION_DELETE_HS2SPRO_USER,
             
             @"ACTION_GET_HS2SPRO_MEMORY_COUNT":ACTION_GET_HS2SPRO_MEMORY_COUNT,
             
             @"MEMORY_COUNT":MEMORY_COUNT,
             
             @"ACTION_GET_HS2SPRO_MEMORY_DATA":ACTION_GET_HS2SPRO_MEMORY_DATA,
             
             @"MEMORY_DATA":MEMORY_DATA,
             
             @"ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_COUNT":ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_COUNT,
             
             @"ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_DATA":ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_DATA,
             
             @"ACTION_DELETE_HS2SPRO_ANONYMOUS_MEMORY_DATA":ACTION_DELETE_HS2SPRO_ANONYMOUS_MEMORY_DATA,
             
             @"ACTION_ONLINE_WEIGHTANDBody_INFO":ACTION_ONLINE_WEIGHTANDBody_INFO,
             
             @"ACTION_MEASURE_FINISH":ACTION_MEASURE_FINISH,
             
             @"ACTION_RESET_DEVICE":ACTION_RESET_DEVICE,
             
             @"ACTION_BroadCastType_DEVICE":ACTION_BroadCastType_DEVICE,
             
             @"HS2SPRO_DEVICE_BATTERY":HS2SPRO_DEVICE_BATTERY,
             
             @"HS2SPRO_DEVICE_UNIT":HS2SPRO_DEVICE_UNIT,
             
             @"HS2SPRO_DEVICE_USER_COUNT":HS2SPRO_DEVICE_USER_COUNT,
             
             @"HS2SPRO_BODYBUILDING":HS2SPRO_BODYBUILDING,
             
             @"HS2SPRO_IMPEDANCE":HS2SPRO_IMPEDANCE,
             
             @"HS2SPRO_HEIGHT":HS2SPRO_HEIGHT,
             
             @"HS2SPRO_AGE":HS2SPRO_AGE,
             
             @"HS2SPRO_GENDER":HS2SPRO_GENDER,
             
             @"HS2SPRO_WEIGTH":HS2SPRO_WEIGTH,
             
             @"HS2SPRO_CREATE_TIME":HS2SPRO_CREATE_TIME,
             
             @"HS2SPRO_USER_ID":HS2SPRO_USER_ID,
             
             @"HS2SPRO_USER_NUM":HS2SPRO_USER_NUM,
             
             @"HS2SPRO_IMPEDANCE_ENCRYPT":HS2SPRO_IMPEDANCE_ENCRYPT,
             
             @"HS2SPRO_INSTRUCTION_TYPE":HS2SPRO_INSTRUCTION_TYPE,
             
             @"HS2SPRO_DATA_BODY_FAT_RESULT":HS2SPRO_DATA_BODY_FAT_RESULT,
             
             @"ACTION_HS2SPRO_ONLINE_DATA":ACTION_HS2SPRO_ONLINE_DATA,
             
             @"ACTION_HS2SPRO_ONLINE_RESULT":ACTION_HS2SPRO_ONLINE_RESULT,
             
             @"ACTION_HS2SPRO_BODYFAT_RESULT":ACTION_HS2SPRO_BODYFAT_RESULT,
             
             @"ACTION_HS2SPRO_MEASURE_FINISH":ACTION_HS2SPRO_MEASURE_FINISH,
             
             @"ACTION_HS2SPRO_RESET_DEVICE":ACTION_HS2SPRO_RESET_DEVICE,
             
             @"HS2SPRO_FAT_WEIGHT":HS2SPRO_FAT_WEIGHT,
             
             @"HS2SPRO_FAT_CONTROL":HS2SPRO_FAT_CONTROL,
             
             @"HS2SPRO_WEIGHT_CONTROL":HS2SPRO_WEIGHT_CONTROL,
             
             @"HS2SPRO_BMI":HS2SPRO_BMI,
             
             @"HS2SPRO_BMR":HS2SPRO_BMR,
             
             @"HS2SPRO_RIGHT_TIME":HS2SPRO_RIGHT_TIME,
             
             @"HS2SPRO_IMPEDANCE_ERROR":HS2SPRO_IMPEDANCE_ERROR,
             
             @"HS2SPRO_ANONYMOUSMEMORY_COUNT":HS2SPRO_ANONYMOUSMEMORY_COUNT,
             
             @"HS2SPRO_STANDARD_WEIGHT":HS2SPRO_STANDARD_WEIGHT,
             
             @"HS2SPRO_SKELETAL_MUSCLE_MASS":HS2SPRO_SKELETAL_MUSCLE_MASS,
             
             @"HS2SPRO_BODY_WATER_RATE":HS2SPRO_BODY_WATER_RATE,
             
             @"HS2SPRO_MUSCLE_MASS":HS2SPRO_MUSCLE_MASS,
             
             @"HS2SPRO_MUSCLE_CONTROL":HS2SPRO_MUSCLE_CONTROL,
             
             @"HS2SPRO_PHYSICAL_AGE":HS2SPRO_PHYSICAL_AGE,
             
             @"HS2SPRO_VISCERAL_FAT_GRADE":HS2SPRO_VISCERAL_FAT_GRADE,
             
             @"HS2SPRO_PROTEIN_RATE":HS2SPRO_PROTEIN_RATE,
             
             @"HS2SPRO_BONE_SALT_CONTENT":HS2SPRO_BONE_SALT_CONTENT,
             
             @"HS2SPRO_BODY_FIT_PERCENTAGE":HS2SPRO_BODY_FIT_PERCENTAGE,
             
             @"HS2SPRO_MEASURE_TIME":HS2SPRO_MEASURE_TIME,
             
             @"ACTION_HS2SPRO_START_MEASURE_HEARTRATE":ACTION_HS2SPRO_START_MEASURE_HEARTRATE,
             
             @"HS2SPRO_HEARTRATE":HS2SPRO_HEARTRATE,
             
             @"ACTION_HS2SPRO_MEASURE_HEARTRATE_FAIL":ACTION_HS2SPRO_MEASURE_HEARTRATE_FAIL,
             
             @"ACTION_HS2SPRO_MEASURE_RESULT":ACTION_HS2SPRO_MEASURE_RESULT,
             };

}


+ (BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
