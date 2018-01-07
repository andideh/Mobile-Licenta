import styles from '../styles/styles'
import FlatsList from './FlatsList';
import FlatEdit from './FlatEdit';
import React from 'react';
import Report from './Report.js';
import { AsyncStorage, Text, View, ListView, TouchableHighlight, AlertIOS } from 'react-native';

class FlatsListContainer extends React.Component {
    constructor() {
        super();

        this.state = {
            items: []
        }

        this.alertMenu = this.alertMenu.bind(this);
        this.deleteItem = this.deleteItem.bind(this);
        this.updateItem = this.updateItem.bind(this);
        this.openItem = this.openItem.bind(this);
        this.showReport = this.showReport.bind(this);

        this.loadFromStorage();
        // AsyncStorage.clear();
    }


    loadFromStorage() {
        AsyncStorage.getItem("flatsKey", (err, result) => {
            let unarchived = JSON.parse(result);

            if (unarchived != null) {
                this.setState({ items: unarchived });
            }
        });
    }

    alertMenu(rowData, rowID) {
        AlertIOS.alert(
            'Quick Menu',
            null,
            [
                {text: 'Delete', onPress: () => this.deleteItem(rowID)},
                {text: 'Edit', onPress: () => this.openItem(rowData, rowID)},
                {text: 'Cancel'}
            ]
        )
    }

    saveToDisk() {
        let archived = JSON.stringify(this.state.items);
        AsyncStorage.setItem("flatsKey", archived);
    }

    deleteItem(index) {
        var items = this.state.items;
        items.splice(index, 1);
        this.setState({items: items});
        this.saveToDisk();
    }

    updateItem(item, index) {
        var items = this.state.items;
        if (index) {
            items[index] = item;
        }
        else {
            items.push(item)
        }
        this.setState({items: items});
        this.props.navigator.pop();
        this.saveToDisk();
    }

    openItem(rowData, rowID) {
        this.props.navigator.push({
            title: rowData && rowData.txt || 'New Item',
            component: FlatEdit,
            passProps: {item: rowData, id: rowID, update: this.updateItem }
        });
    }

    showReport() {
        let items = this.state.items;

        this.props.navigator.push({
            title: "Report",
            component: Report,
            passProps: { items: this.state.items }
        });
    }

    render() {
        return (
            <View style={{flex:1}}>
                <FlatsList
                    items={this.state.items}
                    onPressItem={this.openItem}
                    onLongPressItem={this.alertMenu}/>
                <TouchableHighlight
                    style={[styles.button, styles.newButton]}
                    underlayColor='#99d9f4'
                    onPress={this.openItem}>
                    <Text style={styles.buttonText}>+</Text>
                </TouchableHighlight>
                <TouchableHighlight
                    style={[styles.button, styles.newButton]}
                    underlayColor='#99d9f4'
                    onPress={this.showReport}>
                    <Text style={styles.buttonText}>Show statistics</Text>
                </TouchableHighlight>
            </View>
        );
    }
}

module.exports = FlatsListContainer;
