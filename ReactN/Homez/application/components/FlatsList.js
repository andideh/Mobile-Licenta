import styles from '../styles/styles';
import FlatListItem from './FlatListItem';
import React from 'react';
import {
    ListView
} from 'react-native';

class FlatsList extends React.Component {
    constructor(){
        super();
    }
    componentWillMount() {
        this.dataSource = new ListView.DataSource({
            rowHasChanged: (row1, row2) => row1 !== row2
        });
    }

    render() {
        var dataSource = this.dataSource.cloneWithRows(this.props.items);
        return (
            <ListView
                dataSource={dataSource}
                renderRow={(rowData, sectionID, rowID) =>
          <FlatListItem item={rowData}
          onPress={() => this.props.onPressItem(rowData, rowID)}
          onLongPress={() => this.props.onLongPressItem(rowData, rowID)} />
        }
                style={styles.listView}/>
        );
    }

}


export default FlatsList;
