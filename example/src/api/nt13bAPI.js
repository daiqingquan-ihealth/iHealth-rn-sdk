import { NT13BModule } from '@ihealth/ihealthlibrary-react-native'

export default {
  apis: {
    getAllConnectedDevices: () => NT13BModule.getAllConnectedDevices(),
    measure: (mac) => NT13BModule.measure(mac),
    disconnect: (mac) => NT13BModule.disconnect(mac),
  }
}
