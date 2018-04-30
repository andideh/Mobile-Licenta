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

private typealias JSON = [String:Any]

class NetworkService: ServiceType {
    
    // MARK: - Private properties
    
    private let dbRef = Database.database().reference()
    private let scheduler = QueueScheduler(qos: .background, name: "com.alz-study", targeting: nil)

    
    // MARK: - Public methods
    
    func signup(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return Auth.auth().createUser(email: email, password: password)
    }
    
    
    func login(email: String, password: String) -> SignalProducer<Firebase.User, ASError> {
        return Auth.auth().login(email: email, password: password)
    }
    
    
    func store(newUser: Firebase.User, role: UserRole) -> SignalProducer<DatabaseReference, ASError> {
        let path = Endpoint.users.rawValue
                        .appendingPath(String(newUser.uid))
        let reference = dbRef.child(path)
        
        return reference.setValue([
                Endpoint.role.rawValue : role.rawValue
            ])
    }
    
    
    func update(userProfile: UserProfile, uid: String) -> SignalProducer<DatabaseReference, ASError> {
        let path = Endpoint.userProfiles.rawValue
                    .appendingPath(String(uid))
        let reference = dbRef.child(path)
        let json = userProfile.toJSON()
        
        return reference.setValue(json)
    }
    
    func fetchTodayActivity() -> SignalProducer<DailyActivity, ASError> {
        let today = Date()
        let timestamp = dateFormatter.string(from: today)
        let uid = AppEnvironment.current.currentUser!.uid
        let path = Endpoint.activities.rawValue
                        .appendingPath(uid)
                        .appendingPath(timestamp)
        
        let reference = dbRef.child(path)
        
        return reference.observeEvent(of: .value)
            .flatMap(.latest, self.decode(from:))
    }
    
    func createTodayActivity() -> SignalProducer<DailyActivity, ASError> {
        let activity = DailyActivityFactory.makeNewActivity()
        let timestamp = activity.timestamp
        let uid = AppEnvironment.current.currentUser?.uid ?? ""
        let path = Endpoint.activities.rawValue
                        .appendingPath(uid)
                        .appendingPath(timestamp)
        let ref = dbRef.child(path)
        let json = activity.toJSON()

        return ref.setValue(json)
            .flatMap(.latest) { _ in
                return SignalProducer<DailyActivity, ASError> { obs, _ in
                    obs.send(value: activity)
                    obs.sendCompleted()
                }
            }

//        return SignalProducer<DailyActivity, ASError> { obs, _ in
//            obs.send(value: activity)
////            obs.sendCompleted()
//
////            after(5.0, block: {
////                let done = DailyActivityFactory.makeDoneDailyTask()
////                obs.send(value: done)
////            })
//        }
    }
    
    func update(test: Test) -> SignalProducer<DatabaseReference, ASError> {
        let today = Date()
        let key = dateFormatter.string(from: today)
        let uid = AppEnvironment.current.currentUser?.uid ?? ""
        let testKey = test.type.rawValue
        let json = test.toJSON()
        let ref = Database.database().reference(withPath: "tasks/\(uid)/\(key)/tests/\(testKey)")
        
        return ref.setValue(json)
    }
    
    func update(task: Activity) -> SignalProducer<DatabaseReference, ASError> {
        let today = Date()
        let key = dateFormatter.string(from: today)
        let uid = AppEnvironment.current.currentUser?.uid ?? ""
        let taskKey = String(task.type.rawValue)
        
        let path = Endpoint.activities.rawValue
                        .appendingPath(uid)
                        .appendingPath(key)
                        .appendingPath(Endpoint.tasks.rawValue)
                        .appendingPath(taskKey)
        let ref = dbRef.child(path)
        
        let json = task.toJSON()
        
        return ref.setValue(json)
    }
    
    
    func fetchYesterdayActivity() -> SignalProducer<DailyActivity, ASError> {
        let yesterday = Date().addingTimeInterval(-60 * 60 * 24)
        let timestamp = dateFormatter.string(from: yesterday)
        let uid = AppEnvironment.current.currentUser?.uid ?? ""
        let path = Endpoint.activities.rawValue
                        .appendingPath(uid)
                        .appendingPath(timestamp)
        
        let ref = dbRef.child(path)
        
        return ref.observeSingleEvent(of: .value)
            .flatMap(.latest, self.decode(from:))
    }
    
    func fetchProfile() -> SignalProducer<UserProfile, ASError> {
        let uid = AppEnvironment.current.currentUser?.uid ?? ""
        let path = Endpoint.userProfiles.rawValue.appendingPath(uid)
        
        let ref = dbRef.child(path)
        
        return ref.observeSingleEvent(of: .value)
            .flatMap(.latest, self.decode(from:))
    }
    
    func logout() -> SignalProducer<(), ASError> {
        return Auth.auth().logout()
    }
    
    func fetchUserRole(for user: User) -> SignalProducer<(User, UserRole), ASError> {
        let path = Endpoint.users.rawValue.appendingPath(user.uid)
        let ref = dbRef.child(path)
        
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
        let path = Endpoint.userProfiles.rawValue
        let ref = dbRef.child(path)
        
        return ref.observeEvent(of: .value)
            .flatMap(.latest) { snapshot -> SignalProducer<[String: UserProfile], ASError> in
                return SignalProducer<[String: UserProfile], ASError> { obs, _ in
                    if let json = snapshot.value as? [String:[String:Any]] {
                        var profilesJSON: [[String:Any]] = []
                        for (_, value) in json {
                            profilesJSON.append(value)
                        }
                        
                        let profiles = try! profilesJSON.map(UserProfile.init(with:))
                        let zipped = zip(json.keys, profiles)
                        let values = Dictionary(uniqueKeysWithValues: zipped)
                       
                        obs.send(value: values)
                    } else {
                        obs.send(error: ASError.jsonParseError)
                    }
                }
            }
    }
    
    
    // MARK: - Private methods
    
    private func decode<T: Decodable>(from snapshot: DataSnapshot) -> SignalProducer<T, ASError> {
        return snapshotToJSON(snapshot)
            .flatMap(.latest) { json -> SignalProducer<T, ASError> in
                return SignalProducer<T, ASError> { obs, _ in
                    
                    do {
                        let model = try T.init(with: json)
                        
                        obs.send(value: model)
                        obs.sendCompleted()
                        
                    } catch let error {
                        print(error)
                        
                        obs.send(error: .jsonParseError)
                    }
                }
                    
            }
            .start(on: scheduler)
    }
    
    private func decode<T: Decodable>(from snapshot: DataSnapshot) -> SignalProducer<[T], ASError> {
        return snapshotToJSONArray(snapshot)
            .flatMap(.latest) { jsonArray -> SignalProducer<[T], ASError> in
                return SignalProducer<[T], ASError> { obs, _ in
                    do {
                        let models = try jsonArray.map(T.init(with:))
                        
                        obs.send(value: models)
                        obs.sendCompleted()
                    } catch let error {
                        print(error)
                        obs.send(error: .jsonParseError)
                    }
                }
            }
            .start(on: scheduler)
    }
    
    private func encode<T: Encodable>(_ model: T) -> Result<Data, ASError> {
        let encoder = JSONEncoder()
        
        do {
            let json = try encoder.encode(model)
            return .success(json)
        } catch let error {
            print(error)
            return .failure(.jsonParseError)
        }
    }
    
    private func encode<T: Encodable>(_ models: [T]) -> Result<Data, ASError> {
        let encoder = JSONEncoder()
        
        do {
            let json = try encoder.encode(models)
            return .success(json)
        } catch let error {
            print(error)
            return .failure(.jsonParseError)
        }
    }
    
    private func snapshotToJSON(_ snapshot: DataSnapshot) -> SignalProducer<JSON, ASError> {
        return SignalProducer<JSON, ASError> { obs, _ in
            if let json = snapshot.value as? JSON {
                obs.send(value: json)
                obs.sendCompleted()
            } else {
                obs.send(error: .jsonParseError)
            }
        }
    }
    
    private func snapshotToJSONArray(_ snapshot: DataSnapshot) -> SignalProducer<[JSON], ASError> {
        return SignalProducer<[JSON], ASError> { obs, _ in
            if let array = snapshot.value as? [JSON] {
                obs.send(value: array)
                obs.sendCompleted()
            } else {
                obs.send(error: .jsonParseError)
            }
        }
    }
}


private struct DailyActivityFactory {
   
    static func makeNewActivity() -> DailyActivity {
        let today = Date()
        let timestamp = dateFormatter.string(from: today)

        let tasks = [
            Activity(type: .personRecognition),
            Activity(type: .colorRecognition),
            Activity(type: .rememberNumbers),
            Activity(type: .objectRecognition),
            Activity(type: .glucoseLevel)
        ]
        return DailyActivity(timestamp: timestamp, tasks: tasks)
    }
    
    
    // TODO: Remove this
    static func makeDoneDailyTask() -> DailyActivity {
        let now = Date()
        let yesterday = now.addingTimeInterval( -60 * 60 * 24)
        let timestamp = dateFormatter.string(from: yesterday)

        let tasks = [
            Activity(type: .rememberNumbers, isDone: true),
            Activity(type: .colorRecognition, isDone: true),
            Activity(type: .personRecognition, isDone: true),
            Activity(type: .objectRecognition, isDone: true),
            Activity(type: .glucoseLevel, isDone: true)
        ]

        return DailyActivity(timestamp: timestamp, tasks: tasks)
    }
}
