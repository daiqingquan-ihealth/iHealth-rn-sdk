'use strict';
var { TurboModuleRegistry } = require('react-native');
var RCTModule = TurboModuleRegistry.get('NT13BModule');
// Pre-call addListener via TurboModule JSI to ensure _listenerCount > 0.
// Without this, sendEventWithName: silently drops all events in New Architecture.
if (RCTModule && typeof RCTModule.addListener === 'function') {
  try { RCTModule.addListener('event_notify_nt13b'); } catch (_) {}
}

function measure(mac) {
  RCTModule?.measure(mac);
}

module.exports = {
  Event_Notify: 'event_notify_nt13b',
  getAllConnectedDevices: () => { RCTModule?.getAllConnectedDevices(); },
  getBattery: (mac) => { RCTModule?.getBattery?.(mac); },
  measure: measure,
  stopMeasure: (mac) => { RCTModule?.stopMeasure?.(mac); },
  disconnect: (mac) => { RCTModule?.disconnect(mac); },
};
