//
//  IgnoreValues.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


extension Signal {
    
    func ignoreValues() -> Signal<Void, Error> {
        return self.map { _ in return () }
    }
}

extension SignalProducer {
    
    func ignoreValues() -> SignalProducer<Void, Error> {
        return lift { $0.ignoreValues() }
    }
}
