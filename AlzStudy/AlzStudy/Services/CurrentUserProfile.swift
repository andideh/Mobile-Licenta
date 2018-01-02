//
//  CurrentUserProfile.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 03/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase

final class CurrentUserProfile: NSObject, NSCoding {
    
    var age: Int = -1
    var weight: Int = -1
    var height: Int = -1
    var gender: Gender = .male
    
    private enum Keys: String {
        case age, weight, height, gender
    }
    
    override init() {
        super.init()
    }
    
    init(age: Int, weight: Int, height: Int, gender: Gender) {
        super.init()

        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
    }
    
    init?(with snapshot: DataSnapshot) {
        guard let json = snapshot.value as? [String: Any] else { return nil }
        
        self.age = json["age"] as! Int
        self.weight = json["weight"] as! Int
        self.height = json["height"] as! Int
        let genderRawValue = json["gender"] as! Int
        self.gender = Gender(rawValue: genderRawValue)!
    }
    
    init?(coder aDecoder: NSCoder) {
        self.age = aDecoder.decodeInteger(forKey: Keys.age.rawValue)
        self.weight = aDecoder.decodeInteger(forKey: Keys.weight.rawValue)
        self.height = aDecoder.decodeInteger(forKey: Keys.height.rawValue)
        let genderRawValue = aDecoder.decodeInteger(forKey: Keys.gender.rawValue)
        self.gender = Gender(rawValue: genderRawValue)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.age, forKey: Keys.age.rawValue)
        aCoder.encode(self.weight, forKey: Keys.weight.rawValue)
        aCoder.encode(self.height, forKey: Keys.height.rawValue)
        aCoder.encode(self.gender.rawValue, forKey: Keys.gender.rawValue)
    }
}

extension CurrentUserProfile {
    
    func toJSON() -> [String:Any] {
        return [
            "age":self.age,
            "weight":self.weight,
            "height":self.height,
            "gender":self.gender.rawValue
        ]
    }
}

