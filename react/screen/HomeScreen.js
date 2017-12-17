import React, { Component } from 'react';

import { View, Button, FlatList, Text, StyleSheet }
  from 'react-native'

import {
    Cell, 
    Section,
    TableView,
  } from 'react-native-tableview-simple';
import EditFlat from './EditFlat';

export class HomeScreen extends Component {
  static navigationOptions = ({navigation}) => ({
    title: 'Available flats',
  })
  render() {
    const { navigate, goBack } = this.props.navigation
    const username = this.props.navigation.state.username
    const password = this.props.navigation.state.password

    const id = '1'
    const address = 'Republicii'
    const price = '700'

    return (
      <View style={styles.container}>
        <TableView>
          <Section footer="All rights reserved.">
           <Cell title={address} titleTextColor="#007AFF" onPress={() => 
                navigate('EditFlat', {id: id, address: address, price: price})
          }/>
           
           <Cell title="Flat 2" titleTextColor="#007AFF" onPress={() =>           
                 navigate('EditFlat', {id, address, price})}
           />
           <Cell title="Flat 3" titleTextColor="#007AFF" onPress={() =>             
               navigate('EditFlat', {id, address, price})}

           />
           <Cell title="Flat 4" titleTextColor="#007AFF" onPress={() =>                 
            navigate('EditFlat', {id, address, price})
          }
           
           />
           <Cell title="Flat 5" titleTextColor="#007AFF" onPress={() => 
            navigate('EditFlat', {id, address, price})
          }
           
           />

          </Section>
        </TableView>

      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  
})
