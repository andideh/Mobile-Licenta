//
//  Firebase+Reactive.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/31/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase
import ReactiveSwift
import Result

let scheduler = QueueScheduler(qos: .default, name: "com.andi.alzstudy")

extension Firebase.Auth {
    
    func createUser(email: String, password: String) -> SignalProducer<Firebase.User, NSError> {
        return SignalProducer<Firebase.User, NSError> { obs, _ in
            self.createUser(withEmail: email, password: password, completion: { user, error in
                if let user = user {
                    obs.send(value: user)
                    obs.sendCompleted()
                } else if let error = error {
                    obs.send(error: error as NSError)
                } else {
                    obs.sendCompleted()
                }
            })
        }
        .start(on: scheduler)
    }
}
