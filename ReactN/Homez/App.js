import styles from './application/styles/styles';
import FlatsListContainer from './application/components/FlatsListContainer';
import React from 'react';
import {
  NavigatorIOS
} from 'react-native';

class FlatsApp extends React.Component {
    render() {
        return (
            <NavigatorIOS
                style={styles.navigator}
                initialRoute={{component: FlatsListContainer, title: 'Homez'}}/>
        );
    }
}

export default FlatsApp;
