import React from 'react'
import { View, Text, StyleSheet, ScrollView } from 'react-native'
import { ListItem } from '@rneui/themed';


const DeviceTypes = [
    'AM3S', 'AM4', 'AM5', 'AM6',
    'BG1', 'BG1S', 'BG5', 'BG5S', 'BG1A',
    'BP3L', 'BP5', 'BP5S', 'BP7', 'BP7S', 'KN550',
    'HS2', 'HS4', 'HS4S', 'HS6',
    'PO1', 'PO3',
    'ECG3', 'ECG3USB',
    'FDIR_V3','TS28B', 'NT13B', 'PT3SBT',
    'HS2S', 'HS2S Pro'
]

const SelectScreen = ({ navigation }) => {

  return (
    <ScrollView>
      {
        DeviceTypes.map(item => {
          return (
            <ListItem
              key={item}
              onPress={() => {  
                navigation.navigate('Scan', { type: item });
              }}
              bottomDivider>
              <ListItem.Content>
                <ListItem.Title>{item}</ListItem.Title>
              </ListItem.Content>
              <ListItem.Chevron />
            </ListItem>
          )
        })
      }
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row', 
    justifyContent: 'flex-start', alignItems: 'center',
  },
  textContainer: {
    justifyContent: 'center', alignItems: 'center',
    width: 100, height: 50, 
  },
  picker: {
    flex: 1, 
    height: 50,
  }
})

export default SelectScreen
