//
//  AppDelegate.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 알람 객체 delegate를 AppDelegate에 설정하는 이유
        // 앱이 foreground에 있을 때도 유저 노티를 볼 수 있도록 하기 위함
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //채택후 핸들러 처리를 해주어야 유저 노티를 볼 수 있다.
    //노티를 수신한 이후
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("234")
        completionHandler()
    }
    
    // 노티를 어떤 형식(소리, 배지(앱 아이콘위의 숫자), 배너(구 alert), 리스트)으로 보여줄 것인지 처리가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("2345")
        print(notification.request.content.userInfo)
        completionHandler([.sound, .banner, .list, .badge])
    }
}
