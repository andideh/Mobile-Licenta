//
//  LocalNotificationsService.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 28/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import UserNotifications

private enum NotificationsKeys {
    static let HasScheduledDailyNotifications = "HasScheduledDailyNotifications"
}

final class LocalNotificationsService {
    
    private var hasScheduledDailyNotifications: Bool {
        get { return UserDefaults.standard.bool(forKey: NotificationsKeys.HasScheduledDailyNotifications) }
        set { UserDefaults.standard.set(hasScheduledDailyNotifications, forKey: NotificationsKeys.HasScheduledDailyNotifications) }
    }
    
    // MARK: - Public methods
    
    func t(_ vc: UIViewController) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.showPermissionAlert(on: vc)
                
            case .authorized:
                guard !self.hasScheduledDailyNotifications else { return }
                
                self.hasScheduledDailyNotifications = true
                self.scheduleDailyNotifications()
                
            case .denied: break
            }
        }
    }
    
    // MARK: - Private methods
    
    private func showPermissionAlert(on vc: UIViewController) {
        UIAlertController.show(message: "In order to use the app, please enable local notifications", on: vc) { _ in
            self.registerForLocalNotifications()
        }
    }
    
    private func registerForLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Local notifications error: \(error)")
                
                return
            }
            
            if success {
                self.scheduleDailyNotifications()
            }
        }
    }
    
    private func scheduleDailyNotifications() {
        let center = UNUserNotificationCenter.current()
        let notificationContent = Build(UNMutableNotificationContent()) {
            $0.title = "It works!!!"
            $0.subtitle = "You're the best!"
            $0.sound = UNNotificationSound.default()
        }
        
        let dateComponents = getTriggerDate()
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identif = "com.andi.notif"
        let request = UNNotificationRequest(identifier: identif, content: notificationContent, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Local notifications error: \(error)")
            }
        }
    }
    
    private func getTriggerDate() -> DateComponents {
        let calendar = Calendar.current
        let now = Date()
        let date14h = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date14h)
        
        return components
    }
}
