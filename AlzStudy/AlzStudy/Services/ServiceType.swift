//
//  ServiceType.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 2/14/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Firebase
import Result

protocol ServiceType {
    
    func signup(email: String, password: String) -> SignalProducer<Firebase.User, ASError>
  
    func login(email: String, password: String) -> SignalProducer<Firebase.User, ASError>
    
    func store(newUser: Firebase.User, role: UserRole) -> SignalProducer<DatabaseReference, ASError>
    
    func createTodayActivity() -> SignalProducer<DailyActivity, ASError>
    
    func update(userProfile: UserProfile, uid: String) -> SignalProducer<DatabaseReference, ASError>
    
    func fetchTodayActivity() -> SignalProducer<DailyActivity, ASError>
    
    func fetchYesterdayActivity() -> SignalProducer<DailyActivity, ASError>
    
    // TBR
    func update(test: Test) -> SignalProducer<DatabaseReference, ASError>
    
    func update(task: Activity) -> SignalProducer<DatabaseReference, ASError>

    func fetchProfile() -> SignalProducer<UserProfile, ASError>
    
    func logout() -> SignalProducer<(), ASError>
    
    func fetchUserRole(for user: User) -> SignalProducer<(User, UserRole), ASError>
    
    func fetchParticipants() -> SignalProducer<[String: UserProfile], ASError>
}
