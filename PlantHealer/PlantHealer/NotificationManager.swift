//
//  NotificationManager.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 27.05.2023.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, isError in
            if success {
                print("All set!")
            } else if let error = isError {
                print("Request Auth error: \(error)")
            }
        }
    }
    
    func reloadLocalNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(title: String, hour: Int, minute: Int) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        notificationContent.body = "Don't forget to water your plant."
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotifications(plant: Plant) {
        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.removeAllPendingNotificationRequests() // Clear any existing notifications

        let content = UNMutableNotificationContent()
        content.title = "Watering Reminder"
        content.body = "It's time to water \(plant.commonName)!"
        content.sound = .default
        
        let wateringType = WateringType.getType(type: plant.wateringFrequency)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: WateringType.getTimeInterval(type: wateringType), repeats: true)
            
        let request = UNNotificationRequest(identifier: String(plant.id), content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    // Handle notification scheduling failure
                    print("Error scheduling notification: \(error)")
                }
            }
//        }
    }
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
