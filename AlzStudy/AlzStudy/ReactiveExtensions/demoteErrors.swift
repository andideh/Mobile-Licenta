//
//  demoteErrors.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 13/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


extension SignalProtocol {
    
    func demoteErrors() -> Signal<Value, NoError> {
        return self.signal.flatMapError { _ in return .empty }
    }
}
