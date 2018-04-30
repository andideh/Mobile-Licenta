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

private let scheduler = QueueScheduler(qos: .default, name: "com.andi.alzstudy")

extension Firebase.Auth {
    
    func createUser(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return SignalProducer<Firebase.User, ASError> { obs, disposable in
            self.createUser(withEmail: email, password: password, completion: { user, error in
                if let user = user {
                    obs.send(value: user)
                    obs.sendCompleted()
                } else if error != nil {
                    print("FirebaseError: \(error!)")
                    obs.send(error: .firebaseError)
                } else {
                    obs.sendCompleted()
                }
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
            }
        }
        .start(on: scheduler)
    }
    
    func logout() -> SignalProducer<(), ASError> {
        return SignalProducer<(), ASError> { obs, disposable in
            do {
                try self.signOut()
                obs.send(value: ())
                obs.sendCompleted()
            } catch {
                obs.send(error: .logoutError)
            }
            
            disposable.observeEnded {
                obs.sendInterrupted()
            }
        }
        .start(on: scheduler)
    }
    
    func login(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return SignalProducer<Firebase.User, ASError> { obs, disposable in
            self.signIn(withEmail: email, password: password, completion: { user, error in
                if let user = user {
                    obs.send(value: user)
                    obs.sendCompleted()
                } else if error != nil {
                    print("FirebaseError: \(error!)")
                    obs.send(error: .firebaseError)
                } else {
                    obs.sendCompleted()
                }
                
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
            }
        }
        .start(on: scheduler)
    }
}

extension DatabaseReference {
    
    func setValue(_ value: Any?) -> SignalProducer<DatabaseReference, ASError> {
        return SignalProducer<DatabaseReference, ASError> { obs, disposable in
            self.setValue(value, withCompletionBlock: { error, ref in
                if error != nil {
                    print("FirebaseError: \(error!)")
                    obs.send(error: .firebaseError)
                } else {
                    obs.send(value: ref)
                    obs.sendCompleted()
                }
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
                self.removeAllObservers()
            }
        }
        .start(on: scheduler)
    }
    
    func updateChildValues(_ values: [String: Any]) -> SignalProducer<DatabaseReference, ASError> {
        return SignalProducer<DatabaseReference, ASError> { obs, disposable in
            self.updateChildValues(values, withCompletionBlock: { error, ref in
                if error != nil {
                    print("FirebaseError: \(error!)")
                    obs.send(error: .firebaseError)
                } else {
                    obs.send(value: ref)
                    obs.sendCompleted()
                }
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
                self.removeAllObservers()
            }
        }
        .start(on: scheduler)
    }
    
    func observeSingleEvent(of type: DataEventType) -> SignalProducer<DataSnapshot, NoError> {
        return SignalProducer<DataSnapshot, NoError> { obs, disposable in
            self.observeSingleEvent(of: type, with: { snapshot in
                obs.send(value: snapshot)
                obs.sendCompleted()
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
                self.removeAllObservers()
            }
        }
        .start(on: scheduler)

    }
    
    func observeEvent(of type: DataEventType) -> SignalProducer<DataSnapshot, NoError> {
        return SignalProducer<DataSnapshot, NoError> { obs, disposable in
            self.observe(type, with: { snapshot in
                obs.send(value: snapshot)
            })
            
            disposable.observeEnded {
                obs.sendInterrupted()
                self.removeAllObservers()
            }
        }
        .start(on: scheduler)

    }
}
