//
//  APIService.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Firebase

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-yyyy"
    return formatter
}()

private let dbRef = Database.database().reference()

protocol ServiceType {
    
    func signup(email: String, password: String) -> SignalProducer<Firebase.User, ASError>
    func login(email: String, password: String) -> SignalProducer<Firebase.User, ASError> 
    func store(newUser: Firebase.User, role: UserRole) -> SignalProducer<DatabaseReference, ASError>
    func createTodayTask() -> SignalProducer<DailyTask, ASError> 
    func update(userProfile: UserProfile, uid: String) -> SignalProducer<DatabaseReference, ASError>
    func fetchTodayTask() -> SignalProducer<DailyTask, ASError>
    func fetchYesterdayTask() -> SignalProducer<DailyTask, ASError>
    func update(test: Test) -> SignalProducer<DatabaseReference, ASError>
    func fetchProfile() -> SignalProducer<UserProfile, ASError>
    func logout() -> SignalProducer<(), ASError>
    func fetchUserRole(for user: User) -> SignalProducer<(User, UserRole), ASError>
    func fetchParticipants() -> SignalProducer<[String: UserProfile], ASError>
}

class NetworkService: ServiceType {
    
    func signup(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return Auth.auth().createUser(email: email, password: password)
    }
    
    func login(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return Auth.auth().login(email: email, password: password)
    }
    
    func store(newUser: Firebase.User, role: UserRole) -> SignalProducer<DatabaseReference, ASError> {
        let reference = Database.database().reference().child("users/\(newUser.uid)")
        
        return reference.setValue(["role":role.rawValue])
    }
    
    func update(userProfile: UserProfile, uid: String) -> SignalProducer<DatabaseReference, ASError> {
        let reference = Database.database().reference().child("user_profiles/\(uid)")
        let json = userProfile.toJSON()
        
        return reference.setValue(json)
    }
    
    func fetchTodayTask() -> SignalProducer<DailyTask, ASError> {
        let today = Date()
        let timestamp = dateFormatter.string(from: today)
        let userId = (Auth.auth().currentUser?.uid)!
        let reference = Database.database().reference().child("tasks/\(userId)/\(timestamp)")
        
        return reference.observeEvent(of: .value)
            .flatMap(.latest) { (snapshot: DataSnapshot) -> SignalProducer<DailyTask, ASError> in
                return SignalProducer<DailyTask, ASError> { obs, _ in
                    if let task = DailyTask(with: snapshot) {
                        obs.send(value: task)
                    } else {
                        obs.send(error: .noTodayTask)
                    }
                }
            }
    }
    
    func createTodayTask() -> SignalProducer<DailyTask, ASError> {
        let todayTask = DailyTaskFactory.makeNewDailyTask()
        let timestamp = todayTask.timestamp
        let userId = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("tasks/\(userId)/\(timestamp)")
        let json = todayTask.toJSON()
        
        return ref.setValue(json)
            .flatMap(.latest) { _ in
                return SignalProducer<DailyTask, ASError> { obs, _ in
                    obs.send(value: todayTask)
                    obs.sendCompleted()
                }
            }
    }
    
    func update(test: Test) -> SignalProducer<DatabaseReference, ASError> {
        let key = dateFormatter.string(from: Date())
        let uid = (Auth.auth().currentUser?.uid)!
        let testKey = test.type.rawValue
        let json = test.toJSON()
        let ref = Database.database().reference(withPath: "tasks/\(uid)/\(key)/tests/\(testKey)")
        
        return ref.setValue(json)
    }
    
    func fetchYesterdayTask() -> SignalProducer<DailyTask, ASError> {
        let yesterday = Date().addingTimeInterval(-60 * 60 * 24)
        let timestamp = dateFormatter.string(from: yesterday)
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference(withPath: "tasks/\(uid)/\(timestamp)")
        
        return ref.observeSingleEvent(of: .value)
            .flatMap(.latest, { (snapshot: DataSnapshot) -> SignalProducer<DailyTask, ASError> in
                return SignalProducer<DailyTask, ASError> { obs, _ in
                    if let task = DailyTask(with: snapshot) {
                        obs.send(value: task)
                        obs.sendCompleted()
                    } else {
                        obs.sendInterrupted()
                    }
                }
            })
    }
    
    func fetchProfile() -> SignalProducer<UserProfile, ASError> {
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("user_profiles/\(uid)")
        
        return ref.observeSingleEvent(of: .value)
            .flatMap(.latest) { (snapshot: DataSnapshot) -> SignalProducer<UserProfile, ASError> in
                return SignalProducer<UserProfile, ASError> { obs, _ in
                    if let profile = UserProfile(with: snapshot) {
                        obs.send(value: profile)
                        obs.sendCompleted()
                    } else {
                        obs.send(error: ASError.jsonParseError)
                    }
                }
            }
    }
    
    func logout() -> SignalProducer<(), ASError> {
        return Auth.auth().logout()
    }
    
    func fetchUserRole(for user: User) -> SignalProducer<(User, UserRole), ASError> {
        let ref = dbRef.child("users/\(user.uid)")
        
        return ref.observeSingleEvent(of: .value)
            .flatMap(.latest) { (snapshot: DataSnapshot) -> SignalProducer<(User, UserRole), ASError> in
                return SignalProducer<(User, UserRole), ASError> { obs, _ in
                    if let json = snapshot.value as? [String:Any],
                        let rawValue = json["role"] as? Int,
                        let role = UserRole(rawValue: rawValue) {
                        
                        obs.send(value: (user, role))
                        obs.sendCompleted()
                    } else {
                        obs.send(error: ASError.jsonParseError)
                    }
                }
            }
    }
    
    func fetchParticipants() -> SignalProducer<[String: UserProfile], ASError> {
        let ref = dbRef.child("user_profiles")
        
        return ref.observeEvent(of: .value)
            .flatMap(.latest) { snapshot -> SignalProducer<[String: UserProfile], ASError> in
                return SignalProducer<[String: UserProfile], ASError> { obs, _ in
                    if let json = snapshot.value as? [String:[String:Any]] {
                        var profilesJSON: [[String:Any]] = []
                        for (_, value) in json {
                            profilesJSON.append(value)
                        }
                        
                        let profiles = profilesJSON.map(UserProfile.init(with:))
                        let zipped = zip(json.keys, profiles)
                        let values = Dictionary(uniqueKeysWithValues: zipped)
                       
                        values.values
                        obs.send(value: values)
                    } else {
                        obs.send(error: ASError.jsonParseError)
                    }
                }
            }
    }
}


private struct DailyTaskFactory {
   
    static func makeNewDailyTask() -> DailyTask {
        let today = Date()
        let timestamp = dateFormatter.string(from: today)
        
        return Build(DailyTask()) {
            $0.timestamp = timestamp
            $0.tests = [
                Test(type: .memory),
                Test(type: .colors),
                Test(type: .numbers),
                Test(type: .glucose)
            ]
        }
    }
    
    static func makeDoneDailyTask() -> DailyTask {
        let now = Date()
        let yesterday = now.addingTimeInterval( -60 * 60 * 24)
        
        let timestamp = dateFormatter.string(from: yesterday)
        
        return Build(DailyTask(), block: {
            $0.timestamp = timestamp
            $0.tests = [
                Test(type: .memory, nrOfTrials: 5, trialsLeft: 3, isDone: true),
                Test(type: .colors, nrOfTrials: 5, trialsLeft: 2, isDone: true),
                Test(type: .numbers, nrOfTrials: 5, trialsLeft: 5, isDone: true),
                Test(type: .glucose, nrOfTrials: 5, trialsLeft: 4, isDone: true)
            ]
        })
    }
}
