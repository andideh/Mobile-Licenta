import React from 'react';
import { StackNavigator } from 'react-navigation';
import { LoginScreen }  from './screens/LoginScreen';


const RootNavigator = StackNavigator({
  Login: {
    screen: LoginScreen,
  },


});

export default RootNavigator;