//
//  SetupDataSource.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


final class SetupDataSource: NSObject {
    
    // MARK: - Public properties
    
    fileprivate(set) var parameters: [ParameterViewData]
    
    // MARK: - Private properties
    override init() {
        parameters = [
            ParameterViewData(type: .age(-1)),
            ParameterViewData(type: .height(0)),
            ParameterViewData(type: .weight(0)),
            ParameterViewData(type: .gender(.male))
        ]
        
        super.init()
    }

    // MARK: - Public methods
    
    // MARK: - Private methods

}

extension SetupDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SetupCell = tableView.dequeReusableCell(forIndexPath: indexPath)
        let parameter = parameters[indexPath.row]
        
        cell.configure(viewData: parameter)
        return cell
    }
    
    
}
