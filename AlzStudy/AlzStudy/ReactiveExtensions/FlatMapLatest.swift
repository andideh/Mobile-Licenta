//
//  FlatMapLatest.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/31/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProtocol {
    
    func flatMapLatest<U>(_ f: @escaping (Value) -> SignalProducer<U, Error>) -> Signal<U, Error> {
        return self.signal.flatMap(.latest, f)
    }
    
    func flatMapLatest<U>(_ f: @escaping (Value) -> Signal<U, Error>) -> Signal<U, Error> {
        return self.signal.flatMap(.latest, f)
    }
}

extension SignalProducerProtocol {
    
    func flatMapLatest<U>(_ f: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return self.producer.flatMap(.latest, f)
    }
    
    func flatMapLatest<U>(_ f: @escaping (Value) -> Signal<U, Error>) -> SignalProducer<U, Error> {
        return self.producer.flatMap(.latest, f)
    }
    
    
}
