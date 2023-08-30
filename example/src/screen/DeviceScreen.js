import React, { useState, useEffect } from 'react'
import { ScrollView } from 'react-native'
import { View, Text } from 'react-native';
import { ListItem } from '@rneui/themed';
import deviceAPIs from '../api/getAPIs';
import useDeviceAPI from '../api/useDeviceAPI';
import useConnectAPI from '../api/useConnectAPI';
import store from '../store';

const DeviceScreen = ({ navigation, route }) => {
  
  const { mac, type } = route.params;
  const { response } = useDeviceAPI(type);
  const { onDisConnectState } = useConnectAPI();

  useEffect(() => {
    console.log('onDisConnectState', onDisConnectState);
    if (onDisConnectState.mac != null || mac == onDisConnectState.mac) {
      navigation.goBack();
    }
    return () => {
      const fn = Reflect.get(deviceAPIs.getDeviceAPI(type).apis, 'disconnect', mac);
      console.log(fn)
      fn(mac);
    }
  }, [onDisConnectState])

  return (
    <ScrollView style={{ flex: 1, flexDirection: 'column' }}>
      <View>
      {
        type ? 
        Object.keys(deviceAPIs.getDeviceAPI(type).apis).map(item => {
          return (
            <ListItem
              key={item}
              onPress={() => {  
                const fn = Reflect.get(deviceAPIs.getDeviceAPI(type).apis, item, mac);
                fn(mac);
              }}
              bottomDivider>
              <ListItem.Content>
                <ListItem.Title>{`Function:  ${item}`}</ListItem.Title>
              </ListItem.Content>
              <ListItem.Chevron />
            </ListItem>
            )
        })
        : <View />
      }
      </View>
      <View style={{ }}>
        <Text style={{ fontSize: 20 }}>{response}</Text>
      </View>
    </ScrollView>
  )
}

export default DeviceScreen;
