import { BP5SModule } from '@ihealth/ihealthlibrary-react-native';

export default {
  apis: {
    getAllConnectedDevices: () => BP5SModule.getAllConnectedDevices(),
    startMeasure: (mac) => BP5SModule.startMeasure(mac),
    stopMeasure: (mac) => BP5SModule.stopMeasure(mac),
    enbleOffline: (mac) => BP5SModule.enbleOffline(mac),
    getBattery: (mac) => BP5SModule.getBattery(mac),
    getOffLineNum: (mac) => BP5SModule.getOffLineNum(mac),
    getOffLineData: (mac) => BP5SModule.getOffLineData(mac),
    deleteData: (mac) => BP5SModule.deleteData(mac),
    getFunctionInfo: (mac) => BP5SModule.getFunctionInfo(mac),
    disconnect: (mac) => BP5SModule.disconnect(mac),
    getHardwareVersion: (mac) => BP5SModule.getHardwareVersion(mac)
  }
}
