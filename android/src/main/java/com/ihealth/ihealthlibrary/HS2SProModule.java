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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@ReactModule(name = "HS2SProModule")
public class HS2SProModule extends iHealthBaseModule {
    private static final String modelName = "HS2SProModule";
    private static final String TAG = "HS2SProModule";

    private static final String EVENT_NOTIFY = "event_notify_hs2spro";

    public HS2SProModule(ReactApplicationContext reactContext) {
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

    private static Hs2sProControl getHs2sProControl(String mac) {
        return iHealthDevicesManager.getInstance().getHs2sProControl(mac);
    }

    @ReactMethod
    public void getDeviceInfo(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.getDeviceInfo();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void disconnect(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac); 
        if (hs2sProControl != null) {
            hs2sProControl.disconnect();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getBattery(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);       
        if (hs2sProControl != null) {
            hs2sProControl.getBattery();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void setUnit(String mac, int unit) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.setUnit(unit);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getUserInfo(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.getUserInfo();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void updateUserInfo(String mac, String id, int createTS, float weight, int age, int height, int gender, int impedance, int bodybuilding) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            byte[] byteId = id.getBytes();
            String ids = ByteBufferUtil.Bytes2HexString(byteId);
            hs2sProControl.createOrUpdateUserInfo(ids, weight, gender, age, height, impedance, bodybuilding);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void deleteUser(String mac, String id) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            byte[] byteId = id.getBytes();
            String ids = ByteBufferUtil.Bytes2HexString(byteId);
            hs2sProControl.deleteUserInfo(ids);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void measure(String mac, int index, String id, int ts, float weight, int age, int height, int gender, int impedance, int bodybuilding) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            if (index == 1) {
                byte[] byteId = id.getBytes();
                String ids = ByteBufferUtil.Bytes2HexString(byteId);
                hs2sProControl.specifyOnlineUsers(ids, weight, gender, age, height, impedance, bodybuilding);
            } else {
                hs2sProControl.specifyTouristUsers();
            }
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getMemoryDataCount(String mac, String id) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            byte[] byteId = id.getBytes();
            String ids = ByteBufferUtil.Bytes2HexString(byteId);
            hs2sProControl.getOfflineDataCount(ids);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getMemoryData(String mac, String id) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            byte[] byteId = id.getBytes();
            String ids = ByteBufferUtil.Bytes2HexString(byteId);
            hs2sProControl.getOfflineData(ids);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void deleteMemoryData(String mac, String id) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            byte[] byteId = id.getBytes();
            String ids = ByteBufferUtil.Bytes2HexString(byteId);
            hs2sProControl.deleteOfflineData(ids);
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getAnonymousMemoryDataCount(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.getAnonymousDataCount();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void getAnonymousMemoryData(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.getAnonymousData();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void deleteAnonymousMemoryData(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.deleteAnonymousData();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void resetDevice(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.restoreFactorySettings();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void setDeviceLightUp(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.setBleLight();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void enterHS2SProHeartRateMeasurementMode(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.startHeartRateMode();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
    }

    @ReactMethod
    public void exitHS2SProHeartRateMeasurementMode(String mac) {
        Hs2sProControl hs2sProControl = getHs2sProControl(mac);
        if (hs2sProControl != null) {
            hs2sProControl.stopHeartRateMode();
            return;
        }
        Log.e(TAG, "Can not find HS2SPRO Control mac:" + mac);
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
        if ("action_set_unit_success".equals(action)) {
            params.putString("action", "action_set_unit");

        } else if ("action_get_user_info".equals(action)) {
            try {
                JSONObject totalObj = new JSONObject(message);
                JSONArray userArr = totalObj.getJSONArray("user_info_array");
                for (int i = 0; i < userArr.length(); i++) {
                    JSONObject obj = userArr.getJSONObject(i);
                    String userId = obj.getString("user_id");
                    obj.put("user_id", hex2Char(userId));
                }
                message = totalObj.toString();
                Utils.jsonToMap(message, params);
            } catch (JSONException e) {
                e.printStackTrace();
            }

        } else if ("action_create_or_update_user_info".equals(action)) {
            int status = params.getInt("status");
            if (status == 2) {
                params.putString("action", "action_error");
                params.putString("describe", "More Than Max Numbers Of User");
                params.putNull("status");
            }
        
        } else if ("action_delete_user_info".equals(action)) {
            int status = params.getInt("status");
            if (status == 2) {
                params.putString("action", "action_error");
                params.putString("describe", "User Not Exist");
            }
           
        } else if ("action_history_data_num".equals(action)) {
            params.putNull("describe");
            params.putNull("status");

        } else if ("action_delete_history_data".equals(action)) {
            int status = params.getInt("status");
            if (status == 2) {
                params.putString("action", "action_error");
                params.putString("describe", "User Not Exist");
            } 
            
        } else if ("action_delete_anonymous_data".equals(action)) {
            // int status = params.getInt("status");
            // params.putInt("result", status);
            params.putNull("describe");
            
        } else if ("action_restore_factory_settings".equals(action)) {
            params.putInt("status", 0);

        } else if ("action_specify_users".equals(action)) {
            int status = params.getInt("status");
            params.putInt("result", status);
            return;

        } else if ("action_heartrate_measure_status".equals(action)) {
            params.putNull("describe");

        } else if ("action_heartrate_realtime_measure".equals(action)) {
            return;

        } else if ("action_stop_heartrate_result".equals(action)) {
            int heartRate = params.getInt("heartrate");
            if (heartRate == 0) {
                params.putString("action", "action_heartrate_measure_fail");
            }

        } else if ("action_stop_heartrate_measure".equals(action)) {
            params.putNull("describe");

        } else if ("action_online_result".equals(action)) {
            int status = params.getInt("status");
            if (status == 2) {
                params.putString("action", "action_error");
                params.putString("describe", "Measure Not Get Stable Weight");
            }
            if (status == 3) {
                params.putString("action", "action_error");
                params.putString("describe", "Measure Timeout");
            }

        } else if ("action_body_fat_result".equals(action)) {
            params.putNull("status");
            params.putNull("describe");
        
        } 
        // else if ("action_error".equals(action)) {
        //     int errorId = params.getInt("error_num");
        //     if (0 == errorId) {
        //         params.putString("describe", "Communication Timeout");

        //     } else if (1 == errorId) {
        //         params.putString("describe", "Received CommandError");

        //     } else if (2 == errorId) {
        //         params.putString("describe", "Input ParameterError");

        //     } else if (3 == errorId) {
        //         params.putString("describe", "More Than Max Numbers Of User");

        //     } else if (4 == errorId) {
        //         params.putString("describe", "Write Flash Error");

        //     } else if (5 == errorId) {
        //         params.putString("describe", "User Not Exist");

        //     } else if (6 == errorId) {
        //         params.putString("describe", "Start Measure Error");

        //     } else if (7 == errorId) {
        //         params.putString("describe", "Measure Timeout");

        //     } else if (8 == errorId) {
        //         params.putString("describe", "Measure Over weight");

        //     } else if (9 == errorId) {
        //         params.putString("describe", "Measure Not Get Stable Weight");

        //     } else if (10 == errorId) {
        //         params.putString("describe", "Disconnect");

        //     } else if (11 == errorId) {
        //         params.putString("describe", "Unsupported");

        //     }
        // }

        sendEvent(EVENT_NOTIFY, params);
    }

    @ReactMethod
    public void getAllConnectedDevices() {
        List<String> devices = iHealthDevicesManager.getInstance().getHs2sProDevices();
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

    public String hex2Char(String hexAsciiCodesString) {
        StringBuilder charString = new StringBuilder();
        for (int i = 0; i < hexAsciiCodesString.length(); i += 2) {
            String hexPair = hexAsciiCodesString.substring(i, i + 2);
            int code = Integer.parseInt(hexPair, 16);
            charString.append((char) code);
        }
        return charString.toString(); 
    }
}
