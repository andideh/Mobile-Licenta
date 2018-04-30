//
//  Errors.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 30/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProtocol where Value: EventProtocol, Error == NoError {
    
    func errors() -> Signal<Value.Error, NoError> {
        return self.signal.map { $0.event.error }.skipNil()
    }
}

extension SignalProducerProtocol where Value: EventProtocol, Error == NoError {
    
    func errors() -> SignalProducer<Value.Error, NoError> {
        return self.producer.lift { $0.errors() }
    }
}
