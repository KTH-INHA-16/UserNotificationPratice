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
    private var disposeBag = Set<AnyCancellable>()
    static let shared = UserNotificationPublicist()
    let userNotificationCenter = UNUserNotificationCenter.current()
    let listSubject = PassthroughSubject<[UNNotificationRequest], Never>()
    let requestSubject = PassthroughSubject<[UNNotificationRequest], Never>()
    let responseSubject = PassthroughSubject<UNNotificationResponse, Never>()
    
    private override init() {
        super.init()
        userNotificationCenter.delegate = self
    }
    
    func deleteRequest(identifiers: Array<String>)  {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        pendingRequests()
    }
    
    func deleteAllRequest() {
        userNotificationCenter.removeAllPendingNotificationRequests()
        pendingRequests()
    }
    
    func pendingRequests() {
        userNotificationCenter.getPendingNotificationRequests { [weak self] requests in
            self?.listSubject.send(requests)
        }
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
        requestSubject.send([notification.request])
        completionHandler([.sound, .badge, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        responseSubject.send(response)
        completionHandler()
    }
}
