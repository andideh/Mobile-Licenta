//
//  Protocols.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String { return String(describing: self) }
}
