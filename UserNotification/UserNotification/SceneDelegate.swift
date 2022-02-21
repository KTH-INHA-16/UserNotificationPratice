//
//  SceneDelegate.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var audioPlayers: Array<AVAudioPlayer> = []
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 다시 화면으로 돌아올 때 뱃지 겟수를 0으로 만듬
        // 해주지 않으면 badge는 없어지지 않음
        UIApplication.shared.applicationIconBadgeNumber = 0
        audioPlayers.forEach { $0.stop() }
        audioPlayers.removeAll()
    }
}

