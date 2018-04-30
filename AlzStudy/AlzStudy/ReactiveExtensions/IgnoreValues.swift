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


extension SignalProtocol {
    
    func ignoreValues() -> Signal<Void, Error> {
        return self.signal.map { _ in return () }
    }
}

extension SignalProducerProtocol {
    
    func ignoreValues() -> SignalProducer<Void, Error> {
        return self.producer.lift { $0.ignoreValues() }
    }
}
