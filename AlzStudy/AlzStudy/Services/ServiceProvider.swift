//
//  ServiceProvider.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 28/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


class ServiceProvider {
    
    // MARK: - Private properties
    
    private var serviceRegistry: [String:Any] = [:]
    
    // MARK: - Public methods
    
    func register<T>(service: T) {
        let key = String(describing: T.self)
        
        self.serviceRegistry[key] = service
    }
    
    func register(services: [Any]) {
        services.forEach { self.register(service: $0) }
    }
    
    func getService<T>() -> T {
        let key = String(describing: T.self)
        
        return self.serviceRegistry[key] as! T
    }
    
    
    
}
