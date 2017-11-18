//
//  AppEnvironment.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

/**
 A global stack that captures the current state of global objects that the app wants access to.
 */
struct AppEnvironment {
    

    /// A global stack of environments.
    fileprivate static var stack: [Environment] = [Environment()]
    
    
    /// The most recent environment on the stack.
    static var current: Environment! {
        return stack.last
    }

    static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    @discardableResult
    static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
    
    static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }

    
    static func pushEnvironment(
        currentUser: User? = current.currentUser) {
        
        pushEnvironment(
            Environment(
                currentUser: currentUser
            )
        )
    }

    
}
