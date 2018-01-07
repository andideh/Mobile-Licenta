'use strict';
import styles from '../styles/styles';
import t  from 'tcomb-form-native';
import React from 'react';
import { View, TouchableHighlight, Text } from 'react-native';
var Form = t.form.Form;

const Currency = t.enums({
    'EU': 'Euro',
    'DL': 'Dolar',
    "LE": "Lei"
  }, 'Currency');

var Flat = t.struct({
    address: t.Str,
    price: t.Number,
    nrRooms: t.Number,
    neighborhood: t.Str,
    currency: Currency,
    sold: t.Bool});

var options = {
    fields: {
        address: {
            label: 'Address',
            placeholder: 'enter address here',
            autoFocus: false
        },

        price: {
            label: 'Price',
            placeholder: 'enter price here',
            autoFocus: false
        }
    }
};

class FlatEdit extends React.Component {
    constructor() {
        super();
        this.onUpdate = this.onUpdate.bind(this);
    }

    onUpdate() {
        var value = this.refs.form.getValue();
        if (value) {
            this.props.update(value, this.props.id);
        }
    }

    render() {
        return (
            <View style={styles.todo}>
                <Form
                    ref="form"
                    type={Flat}
                    onChange={this._onChange}
                    options={options}
                    value={this.props.item}/>
                <TouchableHighlight
                    style={[styles.button, styles.saveButton]}
                    onPress={this.onUpdate}
                    underlayColor='#aad9f4'>
                    <Text style={styles.buttonText}>Save</Text>
                </TouchableHighlight>
            </View>
        )
    }
}


export default FlatEdit;
