import bt550API from './550btAPI'
import bg1aAPI  from './bg1aAPI'
import am6API   from './am6API'
import bg5sAPI   from './bg5sAPI'
import hs2sAPI   from './hs2sAPI'
import hs2sProAPI   from './hs2sProAPI'
import { 
  BG1AModule,
  BP550BTModule,
  AM6Module,
  BG5SModule,
  HS2SModule,
  HS2SProModule
 } from '@ihealth/ihealthlibrary-react-native'

export default {

  getDeviceNotify: (type) => {
    switch(type) {
      case 'KN550':
        return BP550BTModule.Event_Notify

      case 'BG1A':
        return BG1AModule.Event_Notify

      case 'AM6':
        return AM6Module.Event_Notify
        
      case 'BG5S':
        return BG5SModule.Event_Notify

      case 'HS2S':
        return HS2SModule.Event_Notify

      case 'HS2S Pro':
        return HS2SProModule.Event_Notify
    }
  },

  getDeviceAPI: (type) => {
    switch(type) {
      case 'KN550':
        return bt550API

      case 'BG1A':
        return bg1aAPI

      case 'AM6':
        return am6API
      
      case 'BG5S':
        return bg5sAPI

      case 'HS2S':
        return hs2sAPI

      case 'HS2S Pro':
        return hs2sProAPI
            
    }
  }
}
