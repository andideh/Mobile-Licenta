//
//  ValueCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

protocol ValueCell: class {
    associatedtype Value
   
    static var defaultReuseId: String { get }
    
    func configure(with value: Value)
}

extension ValueCell {
    static var defaultReuseId: String { return String(describing: self) }
}
