//
//  Codable.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 2/14/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation

extension Decodable {
    
    init(with json: [String:Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoder = JSONDecoder()
        
        self = try decoder.decode(Self.self, from: data)
    }

}

extension Encodable {
    
    func toJSON() -> [String:Any] {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] ?? [:]
            
            return json
        } catch {
            return [:]
        }
    }
}
