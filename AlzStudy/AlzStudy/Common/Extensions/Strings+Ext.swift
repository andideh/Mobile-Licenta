//
//  Strings+Ext.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/22/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation


extension String {

    func appendingPath(_ path: String) -> String{
        return self.appending("/").appending(path)
    }
}
