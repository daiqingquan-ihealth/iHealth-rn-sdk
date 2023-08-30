import { RecoilRoot } from 'recoil';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import PermissionScreen from './src/screen/PermissionScreen';
import SelectScreen from './src/screen/SelectScreen';
import ScanScreen from './src/screen/ScanScreen';
import DeviceScreen from './src/screen/DeviceScreen';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <RecoilRoot>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="Permission" component={PermissionScreen}/>
          <Stack.Screen name="Select" component={SelectScreen} />
          <Stack.Screen name="Scan" component={ScanScreen} />
          <Stack.Screen name="Device" component={DeviceScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </RecoilRoot>
  );
}

