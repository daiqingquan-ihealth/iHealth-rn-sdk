import { HS2SProModule } from '@ihealth/ihealthlibrary-react-native';

export default {
  apis: {
    getAllConnectedDevices: () => HS2SProModule.getAllConnectedDevices(),
    getDeviceInfo:       (mac) => HS2SProModule.getDeviceInfo(mac),
    getBattery:          (mac) => HS2SProModule.getBattery(mac),
    setUnit:             (mac) => HS2SProModule.setUnit(mac, 1),
    getUserInfo:         (mac) => HS2SProModule.getUserInfo(mac),
    updateUserInfo:      (mac) => HS2SProModule.updateUserInfo(mac, "1234567890123456", 1572317401, 71, 36, 176, 0, 1, 1),
    deleteUser:          (mac) => HS2SProModule.deleteUser(mac, "1234567890123456"),
    getMemoryDataCount:  (mac) => HS2SProModule.getMemoryDataCount(mac, "1234567890123456"),
    getMemoryData:       (mac) => HS2SProModule.getMemoryData(mac, "1234567890123456"),
    deleteMemoryData:    (mac) => HS2SProModule.deleteMemoryData(mac, "1234567890123456"),
    getAnonymousMemoryDataCount: (mac) => HS2SProModule.getAnonymousMemoryDataCount(mac),
    getAnonymousMemoryData:      (mac) => HS2SProModule.getAnonymousMemoryData(mac),
    deleteAnonymousMemoryData:      (mac) => HS2SProModule.deleteAnonymousMemoryData(mac),
    measure:             (mac) => HS2SProModule.measure(mac, 1, "1234567890123456", 1572317401, 71, 36, 176, 0, 1, 1),
    resetDevice:    (mac) => HS2SProModule.resetDevice(mac),
    setDeviceLightUp:    (mac) => HS2SProModule.setDeviceLightUp(mac),
    enterHS2SProHeartRateMeasurementMode: (mac) => HS2SProModule.enterHS2SProHeartRateMeasurementMode(mac),
    exitHS2SProHeartRateMeasurementMode:  (mac) => HS2SProModule.exitHS2SProHeartRateMeasurementMode(mac),
    disconnect:          (mac) => HS2SProModule.disconnect(mac)
  }
}
