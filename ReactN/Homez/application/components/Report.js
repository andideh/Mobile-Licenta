import React, { Component } from 'react';
import { View, Text, StyleSheet } from 'react-native';

import { Pie } from 'react-native-pathjs-charts'

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f7f7f7',
      },
});

class Report extends Component {

constructor() {
        super();

}

  render() {
    let neighborhoods = [
        "Gheorgheni",
        "Marasti",
        "Centru",
        "Grigorescu"]

    let data = [];
    for (x in neighborhoods) {
        let key = neighborhoods[x]
        let count = 0;
      
        for (i in this.props.items) {
            let item = this.props.items[i];
            if (item.neighborhood == key && !item.sold) {
                count = count + 1;
            }
        }

        console.log(this.props.items);
        if (count > 0) {
            let val = {
                "v": count,
                "name": key};
        
            data.push(val);
        }
    }
    // let neighborhoods = {};
    // for (item in this.props.item) {
    //     let key = item.neighborhood;
    //     if (neighborhoods.key == null) {
    //         neighborhoods.key = 1;
    //     } else {
    //         let val = neighborhoods.key;
    //         neighborhoods.key = val + 1;
    //     }
    // }

    let options = {
        margin: {
          top: 20,
          left: 20,
          right: 20,
          bottom: 20
        },
        width: 350,
        height: 350,
        color: '#2980B9',
        r: 50,
        R: 150,
        legendPosition: 'topLeft',
        animate: {
          type: 'oneByOne',
          duration: 200,
          fillTransition: 3
        },
        label: {
          fontFamily: 'Arial',
          fontSize: 8,
          fontWeight: true,
          color: '#ECF0F1'
        }
      }
  
      return (
        <View style={styles.container}>
          <Pie data={data}
            options={options}
            accessorKey="v"
            margin={{top: 20, left: 20, right: 20, bottom: 20}}
            color="#2980B9"
            pallete={
              [
                {'r':25,'g':99,'b':201},
                {'r':24,'g':175,'b':35},
                {'r':190,'g':31,'b':69},
                {'r':100,'g':36,'b':199},
                {'r':214,'g':207,'b':32},
                {'r':198,'g':84,'b':45}
              ]
            }
            r={50}
            R={150}
            legendPosition="topLeft"
            label={{
              fontFamily: 'Arial',
              fontSize: 8,
              fontWeight: true,
              color: '#ECF0F1'
            }}
            />
        </View>
      )
  }
}

export default Report;