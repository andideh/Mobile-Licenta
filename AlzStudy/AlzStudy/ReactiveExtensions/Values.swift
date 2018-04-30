//
//  Values.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 30/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProtocol where Value: EventProtocol, Error == NoError {
    /**
     - returns: A signal of values of `Next` events from a materialized signal.
     */
    public func values() -> Signal<Value.Value, NoError> {
        return self.signal.map { $0.event.value }.skipNil()
    }
}

extension SignalProducerProtocol where Value: EventProtocol, Error == NoError {
    /**
     - returns: A producer of values of `Next` events from a materialized signal.
     */
    public func values() -> SignalProducer<Value.Value, NoError> {
        return self.producer.lift { $0.values() }
    }
}
