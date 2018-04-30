//
//  MapConst.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift


extension Signal {
    
    func mapConst<U>(_ value: U) -> Signal<U, Error> {
        return self.signal.map { _ in return value }
    }
    
}

extension SignalProducer {
    
    func mapConst<U>(_ value: U) -> SignalProducer<U, Error> {
        return lift { $0.mapConst(value) }
    }
}
