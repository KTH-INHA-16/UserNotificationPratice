//
//  UserNotificationPublicist.swift
//  UserNotification
//
//  Created by Nick on 2022/02/17.
//

import Foundation
import Combine
import UserNotifications

final class UserNotificationPublicist: NSObject {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    let responseSubject = PassthroughSubject<UNNotificationResponse, Never>()
    
    override init() {
        super.init()
        userNotificationCenter.delegate = self
    }

    func userNotificationAuth() -> Future<Bool, Never>  {
        return Future<Bool, Never> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            self.userNotificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { success, _ in
                switch success {
                case true:
                    promise(.success(true))
                case false:
                    promise(.success(false))
                }
            }
        }
    }
}

extension UserNotificationPublicist: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        responseSubject.send(response)
        completionHandler()
    }
}
