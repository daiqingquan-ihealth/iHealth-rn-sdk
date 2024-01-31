//
//  HSProfileModule.h
//  ReactNativeIOSLibrary
//
//  Created by ihealth on 16/12/2.
//  Copyright © 2016年 daiqingquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTAssert.h>)
#import <React/RCTBridgeModule.h>
#else
#import <React/RCTBridgeModule.h>
#endif

@interface HS2SProProfileModule : NSObject<RCTBridgeModule>

#define ACTION_LIVEDATA_HS  @"liveData_hs"
#define LIVEDATA_HS  @"value"

#define ACTION_ONLINE_RESULT_HS  @"online_result_hs"
#define DATAID @"dataID"
#define STATUS @"status"

#define WEIGHT_HS  @"value"
#define FAT_HS  @""
#define WATER_HS  @""
#define MUSCLE_HS  @""
#define SKELETON_HS  @""
#define FATELEVEL_HS  @""
#define DCI_HS  @""

#define ACTION_GET_ALL_CONNECTED_DEVICES @"action_get_all_connected_devices"
#define ACTION_HISTORICAL_DATA_HS  @"historicaldata_hs"
#define HISTORDATA_HS  @"historyData"
#define MEASUREMENT_DATE_HS  @"date"
#define ACTION_HISTORICAL_DATA_COMPLETE_HS @"finishTranslate"
#define ACTION_NO_HISTORICALDATA  @"noHistoryData"
#define BATTERY_HS @"battery_hs"
#define ACTION_BATTARY_HS  @"action_get_battery_hs"
#define ACTION_ERROR_HS  @"action_error"
#define ERROR_NUM_HS  @"error"
#define ERROR_ID_ILLEGAL_ARGUMENT  @"400"
#define ERROR_ID_WIFI_DISABLED  @""
#define ERROR_DESCRIPTION_HS @"describe"



#define ACTION_GET_HS2SPRO_DEVICE_INFO @"action_get_device_info"

#define ACTION_SET_HS2SPRO_UNIT  @"action_set_unit"

#define ACTION_GET_HS2SPRO_USER_INFO  @"action_get_user_info"

#define ACTION_UPDATE_HS2SPRO_USER_INFO  @"action_create_or_update_user_info"

#define ACTION_DELETE_HS2SPRO_USER  @"action_delete_user_info"

#define ACTION_GET_HS2SPRO_MEMORY_COUNT  @"action_history_data_num"

#define ACTION_GET_HS2SPRO_MEMORY_DATA  @"action_history_data"

#define ACTION_DELETE_HS2SPRO_MEMORY_DATA  @"action_delete_history_data"

#define ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_COUNT  @"action_anonymous_data_num"

#define ACTION_GET_HS2SPRO_ANONYMOUS_MEMORY_DATA  @"action_anonymous_data"

#define ACTION_DELETE_HS2SPRO_ANONYMOUS_MEMORY_DATA  @"action_delete_anonymous_data"

#define ACTION_HS2SPRO_ONLINE_DATA  @"action_online_real_time_weight"

#define ACTION_HS2SPRO_ONLINE_RESULT  @"action_online_result"

#define ACTION_HS2SPRO_BODYFAT_RESULT  @"action_body_fat_result"

#define ACTION_ONLINE_WEIGHTANDBody_INFO  @"online_weigthandbody_info"

#define ACTION_BroadCastType_DEVICE  @"broadCastType_device"

#define ACTION_RESET_DEVICE  @"reset_device"

#define ACTION_MEASURE_FINISH  @"measure_finish"

#define HS2SPRO_DEVICE_INFO  @"device_info"

#define HS2SPRO_DEVICE_BATTERY  @"battery"

#define HS2SPRO_DEVICE_UNIT  @"unit_current"

#define HS2SPRO_DEVICE_USER_COUNT  @"user_count"

#define HS2SPRO_USER_INFO_ARRAY  @"user_info_array"

#define HS2SPRO_USER_INFO_COUNT  @"user_info_count"

#define HS2SPRO_BODYBUILDING  @"body_building"

#define HS2SPRO_IMPEDANCE  @"impedance"

#define HS2SPRO_HEIGHT  @"height"

#define HS2SPRO_AGE  @"age"

#define HS2SPRO_GENDER  @"gender"

#define HS2SPRO_WEIGTH  @"weight"

#define HS2SPRO_CREATE_TIME  @"create_time"

#define HS2SPRO_INSTRUCTION_TYPE  @"instruction_type"

#define HS2SPRO_USER_ID  @"user_id"

#define HS2SPRO_USER_NUM  @"user_num"

#define HS2SPRO_IMPEDANCE_ENCRYPT  @"impedanceEncrypt"

#define MEMORY_COUNT  @"history_data_count"

#define HS2SPRO_ANONYMOUSMEMORY_COUNT  @"anonymous_data_count"

#define MEMORY_DATA  @"history_data"

#define HS2SPRO_DATA_BODY_FAT_RESULT  @"data_body_fat_result"

#define HS2SPRO_RIGHT_TIME  @"right_time"

#define HS2SPRO_IMPEDANCE_ERROR  @"data_impedance_errors"

#define ACTION_HS2SPRO_MEASURE_FINISH  @"action_measure_finish_at_critical"

#define ACTION_HS2SPRO_RESET_DEVICE  @"action_restore_fatory_settings"

#define HS2SPRO_FAT_WEIGHT  @"fat_weight"

#define HS2SPRO_FAT_CONTROL  @"fat_control"

#define HS2SPRO_WEIGHT_CONTROL  @"weight_control"

#define HS2SPRO_STANDARD_WEIGHT  @"standard_weight"

#define HS2SPRO_SKELETAL_MUSCLE_MASS  @"skeletal_muscle_mass"

#define HS2SPRO_BODY_WATER_RATE  @"body_water_rate"

#define HS2SPRO_MUSCLE_MASS  @"muscle_mass"

#define HS2SPRO_MUSCLE_CONTROL  @"muscle_control"

#define HS2SPRO_PHYSICAL_AGE  @"physical_age"

#define HS2SPRO_VISCERAL_FAT_GRADE  @"visceral_fat_grade"

#define HS2SPRO_PROTEIN_RATE  @"protein_rate"

#define HS2SPRO_BONE_SALT_CONTENT  @"bone_salt_content"

#define HS2SPRO_BODY_FIT_PERCENTAGE  @"body_fit_percentage"

#define HS2SPRO_MEASURE_TIME  @"measure_time"

#define HS2SPRO_BMI  @"bmi"

#define HS2SPRO_BMR  @"bmr"


#define ACTION_HS2SPRO_LightUp_DEVICE  @"action_set_ble_light"

#define HS2SPRO_DEVICE_STATUS  @"device_status"

#define ACTION_HS2SPRO_MEASURE_HEARTRATE_DEVICE_STATUS  @"action_heartrate_measure_status"

#define ACTION_HS2SPRO_START_MEASURE_HEARTRATE  @"action_start_heartrate_measure"

#define ACTION_HS2SPRO_MEASURE_HEARTRATE  @"action_heartrate_realtime_measure"

#define ACTION_HS2SPRO_MEASURE_RESULT  @"action_stop_heartrate_result"


#define ACTION_HS2SPRO_MEASURE_HEARTRATE_FAIL  @"action_heartrate_measure_fail"

#define HS2SPRO_MEASURE_HEARTRATE_RESULT  @"measure_heartrate_result"


#define ACTION_HS2SPRO_EXIT_MEASURE_HEARTRATE_STATUS  @"action_stop_heartrate_measure"


#define HS2SPRO_HEARTRATE  @"heartrate"





@end
