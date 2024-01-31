import { HS2SModule } from '@ihealth/ihealthlibrary-react-native';

export default {
  apis: {
    getAllConnectedDevices: () => HS2SModule.getAllConnectedDevices(),
    getDeviceInfo:       (mac) => HS2SModule.getDeviceInfo(mac),
    getBattery:          (mac) => HS2SModule.getBattery(mac),
    setUnit:             (mac) => HS2SModule.setUnit(mac, 1),
    getUserInfo:         (mac) => HS2SModule.getUserInfo(mac),
    updateUserInfo:      (mac) => HS2SModule.updateUserInfo(mac, "1234567890123456", 1572317401, 71, 20, 180, 0, 1, 1),
    deleteUser:          (mac) => HS2SModule.deleteUser(mac, "1234567890123456"),
    getMemoryDataCount:  (mac) => HS2SModule.getMemoryDataCount(mac, "1234567890123456"),
    getMemoryData:       (mac) => HS2SModule.getMemoryData(mac, "1234567890123456"),
    deleteMemoryData:    (mac) => HS2SModule.deleteMemoryData(mac, "1234567890123456"),
    getAnonymousMemoryDataCount: (mac) => HS2SModule.getAnonymousMemoryDataCount(mac),
    getAnonymousMemoryData:      (mac) => HS2SModule.getAnonymousMemoryData(mac),
    deleteAnonymousMemoryData:      (mac) => HS2SModule.deleteAnonymousMemoryData(mac),
    measure:             (mac) => HS2SModule.measure(mac, 1, "1234567890123456", 1572317401, 71, 20, 180, 0, 1, 1),
    setDeviceLightUp:    (mac) => HS2SModule.setDeviceLightUp(mac),
    enterHS2SHeartRateMeasurementMode: (mac) => HS2SModule.enterHS2SHeartRateMeasurementMode(mac),
    exitHS2SHeartRateMeasurementMode:  (mac) => HS2SModule.exitHS2SHeartRateMeasurementMode(mac),
    disConnect:          (mac) => BG5SModule.disConnect(mac)
  }
}
