import styles from '../styles/styles'
import React from 'react';
import {
    Text, View, TouchableHighlight
} from 'react-native';

class FlatListItem extends React.Component {
    constructor(){
        super();
    }
    render() {
        var item = this.props.item;
        return (
            <View>
                <TouchableHighlight
                    onPress={this.props.onPress}
                    onLongPress={this.props.onLongPress}>
                    <View style={styles.container}>
                        <Text
                            style={[styles.txt, item.sold && styles.completed]}>
                            {item.address}
                        </Text>
                    </View>
                </TouchableHighlight>
                <View style={styles.hr}/>
            </View>
        );
    }
}

module.exports = FlatListItem;
