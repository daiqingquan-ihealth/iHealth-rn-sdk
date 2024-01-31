package com.ihealth.ihealthlibrary;

import android.text.TextUtils;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.ihealth.communication.control.Hs2sControl;
import com.ihealth.communication.control.Hs2sProControl;
import com.ihealth.communication.manager.iHealthDevicesManager;
import com.ihealth.communication.utils.ByteBufferUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ReactModule(name = "HS2SModule")
public class HS2SModule extends iHealthBaseModule {
    private static final String modelName = "HS2SModule";
    private static final String TAG = "HS2SModule";

    private static final String EVENT_NOTIFY = "event_notify_hs2s";

    public HS2SModule(ReactApplicationContext reactContext) {
        super(TAG, reactContext);
    }

    @Override
    public String getName() {
        return modelName;
    }

    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> map = new HashMap<>();
        map.put("Event_Notify", EVENT_NOTIFY);
        return map;
    }

    private static Hs2sControl getHs2sControl(String mac) {
        return iHealthDevicesManager.getInstance().getHs2sControl(mac);
    }


    @ReactMethod
    public void getDeviceInfo(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getDeviceInfo();
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void disconnect(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.disconnect();
            return;
        }   
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getBattery(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getBattery();
            return;
        }        
        Log.e(TAG, "Can not find HS2S/HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void setUnit(String mac, int unit) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.setUnit(unit);
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getUserInfo(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getUserInfo();
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void updateUserInfo(String mac, String id, int createTS, float weight, int age, int height, int gender, int impedance, int bodybuilding) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.createOrUpdateUserInfo(id, weight, gender, age, height, impedance, bodybuilding);
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void deleteUser(String mac, String id) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.deleteUserInfo(id);
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void specifyTouristUsers(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.specifyTouristUsers();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void measure(String mac, int index, String id, int ts, float weight, int age, int height, int gender, int impedance, int bodybuilding) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.specifyOnlineUsers(id, weight, gender, age, height, impedance, bodybuilding);
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getMemoryDataCount(String mac, String id) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getOfflineDataCount(id);
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getMemoryData(String mac, String id) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getOfflineData(id);
            return;
        } 
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void deleteMemoryData(String mac, String id) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.deleteOfflineData(id);
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getAnonymousMemoryDataCount(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getAnonymousDataCount();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void getAnonymousMemoryData(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.getAnonymousData();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void deleteAnonymousMemoryData(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.deleteAnonymousData();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void resetDevice(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.restoreFactorySettings();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void setDeviceLightUp(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.setBleLight();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @ReactMethod
    public void enterHS2SHeartRateMeasurementMode(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.startHeartRateMode();
            return;
        }
        Log.e(TAG, "Can not find HS2S/HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void exitHS2SHeartRateMeasurementMode(String mac) {
        Hs2sControl hs2sControl = getHs2sControl(mac);
        if (hs2sControl != null) {
            hs2sControl.stopHeartRateMode();
            return;
        }
        Log.e(TAG, "Can not find HS2S Control mac:" + mac);
    }

    @Override
    public void handleNotify(String mac, String deviceType, String action, String message) {
        Log.i(TAG, "message -> " + message);
        WritableMap params = Arguments.createMap();
        params.putString("action", action);
        params.putString("mac", mac);
        params.putString("type", deviceType);

        if ("action_history_data".equals(action) || "action_anonymous_data".equals(action)) {
            message = "{\"history_data\":" + message + "}";
        }

        if (!TextUtils.isEmpty(message)) {
            Utils.jsonToMap(message, params);
        }
        if ("battery_hs".equals(action)) {
            params.putString("action", "action_get_battery_hs");
            int battery = params.getInt("battery");
            params.putInt("battery", battery);

        } else if ("action_set_unit_success".equals(action)) {
            params.putString("action", "action_set_unit");
            params.putBoolean("result", true);

        } else if ("action_create_or_update_user_info".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            params.putNull("describe");
            params.putNull("status");

        } else if ("action_delete_user_info".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            params.putNull("describe");
            params.putNull("status");

        } else if ("action_history_data_num".equals(action)) {
            ReadableArray array = params.getArray("history_data_count_array");
            int history_data_count = 0;
            if (array != null && array.size() > 0) {
                history_data_count = array.getMap(0).getInt("history_data_count");
            }
            params.putNull("history_data_count_array");
            params.putNull("history_data_user_count");
            params.putInt("history_data_count", history_data_count);

        } else if ("action_delete_history_data".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            params.putNull("describe");
            params.putNull("status");

        } else if ("action_delete_anonymous_data".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            params.putNull("describe");
            params.putNull("status");
            
        } else if ("action_restore_factory_settings".equals(action)) {
            params.putBoolean("result", true);

        } else if ("action_specify_users".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            params.putNull("describe");
            params.putNull("status");
        }
        sendEvent(EVENT_NOTIFY, params);
    }

    @ReactMethod
    public void getAllConnectedDevices() {
        List<String> devices = iHealthDevicesManager.getInstance().getHs2sDevices();
        WritableMap params = Arguments.createMap();
        if (devices.size() > 0) {
            WritableArray array = Arguments.createArray();
            for (String device : devices) {
                array.pushString(device);
            }
            params.putArray("devices", array);
            params.putString("action", ACTION_GET_ALL_CONNECTED_DEVICES);
        }
        sendEvent(EVENT_NOTIFY, params);  
    }
}
