import React, { Component } from 'react';

import { View, Button, TextInput, Text, StyleSheet, TouchableOpacity }
  from 'react-native'


export default class EditFlat extends Component {
  static navigationOptions = ({navigation}) => ({
      title: 'Edit flat details',
  })

  constructor(props) {
    super(props)
   
    
  }
  render() {
    console.log(JSON.stringify(this.props));

    var id = this.props.id;
    var address = this.props.navigation.params.address;
    var price = this.props.price;

    return (
     

      <View style={styles.container}>
        <Text style={styles.text}> Address </Text>
        <TextInput
                    value = {address}
                    placeholderTextColor= '#fff'
                    style={styles.input}
                    
                />

                    
        <Text style={styles.text}> Price </Text>

                <TextInput
                    value = {price}
                    placeholderTextColor= '#fff'
                    style={styles.input}

                  />


                <TouchableOpacity style={styles.loginButton}

                      >
                    <Text style={styles.buttonText}>Save</Text>
                </TouchableOpacity>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 10,
    marginBottom: 100,
  },


  input: {
    height: 60,
    paddingHorizontal: 10,
    color: '#fff',
    backgroundColor: 'rgba(0,0,0,0.2)',
    marginBottom: 10,
},

loginButton: {
    height: 65,
    backgroundColor: '#2980b9',
    paddingVertical: 22,
},

buttonText: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 20,
    color: '#fff',
},

text: {
  fontWeight: 'bold'
}

})
