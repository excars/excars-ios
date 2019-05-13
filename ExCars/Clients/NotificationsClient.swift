//
//  NotificationsClient.swift
//  ExCars
//
//  Created by akonshin on 13/05/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import UserNotifications
import UIKit

final class NotificationsClient {
    
    enum QuickNotification {
        case rideRequest(receiverName: String)
    }
    
    static let shared = NotificationsClient()
    
    // MARK: - lifecycle
    
    private init() {}
    
    @available(iOS 10.0, *)
    func requestAccess(presentController: UIViewController) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    if !granted {
                        print("Ошибка получения доступа к уведомлениям: \(error?.localizedDescription ?? "")")
                    }
                }
            case .denied:
                print("Не дали доступ")
            @unknown default:
                return
            }
        }
    }
    
    func showQuickNotification(_ qNotification: QuickNotification) {
        let content = UNMutableNotificationContent()
        switch qNotification {
        case .rideRequest(let receiverName):
            content.title = "\(receiverName) requested to join the ride"
        }
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval.leastNormalMagnitude,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "ride",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка создания уведомления: \(error)")
            }
        }
    }
    
}
