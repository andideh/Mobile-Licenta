import React, { Component } from 'react';

import { View, Button, TextInput, Text, TouchableOpacity, KeyboardAvoidingView, StyleSheet, Linking }
  from 'react-native'


export class LoginScreen extends Component {
  static navigationOptions = ({navigation}) => ({
      title: 'Login',
  })
  constructor(props) {
    super(props)
    this.state = {username: '', password: ''}
  }
  render() {
    const { navigate } = this.props.navigation
    const username = this.state.username
    const password = this.state.password

    return (
      <KeyboardAvoidingView  behavior="padding" style={styles.container}>
          <View style={styles.titleContainer}>
              <Text style={styles.title}>
                  Welcome to Homez
                  
              </Text>


          </View>

          <View style={styles.formContainer}>
          <TextInput
                    placeholder="email"
                    placeholderTextColor= '#ffd'
                    style={styles.input}

                    value = {this.state.username}
                    onChangeText = { (text) => this.setState({username: text})}/>

                <TextInput
                    placeholder="password"
                    placeholderTextColor= '#ffd'
                    secureTextEntry
                    style={styles.input}

                    value = {this.state.password}
                    onChangeText = { (text) => this.setState({password: text})}/>


                <TouchableOpacity style={styles.loginButton}
                    onPress={() => navigate('Home', {username, password})}
                    >
                    <Text style={styles.buttonText}>Login</Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.sendMail}
                  onPress= {() =>  Linking.openURL('mailto:andi.dehelean@icloud.com?subject=abcdefg&body=body') }
                >
                    <Text style={styles.mailText}>
                      Send email
                    </Text>
                </TouchableOpacity>
          </View>




      </KeyboardAvoidingView>
  );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#2c3e50',
},

titleContainer: {
    flexGrow: 1,
    alignItems: 'center',   
    paddingTop: 100,     
},

title: {
    textAlign: 'center',
    fontSize: 25,
    fontWeight: 'bold',
    alignItems: 'flex-start',
    color: '#FFFFFF'
},

formContainer: {
  marginBottom: 25, 
  padding: 20,      
},

input: {
  height: 60,
  paddingHorizontal: 10,
  color: '#fff',
  backgroundColor: 'rgba(255,255,255,0.2)',
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

sendMail: {
  alignItems: 'center',
  marginTop: 10
},

mailText: {
  color: '#fff',
  textAlign: 'center'
}

})
