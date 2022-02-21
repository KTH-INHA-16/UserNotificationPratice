//
//  ViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import AVFoundation
import Combine

final class IntervalViewController: UIViewController {
    private var disposeBag = Set<AnyCancellable>()
    private var player: AVAudioPlayer?
    private let userNotificationPublicist = UserNotificationPublicist.shared
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var secondTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNotificationPublicist
            .userNotificationAuth()
            .sink { success in
                //상황에 따라 무언가 하게됨
                switch success {
                case true:
                    break
                case false:
                    break
                }
            }.store(in: &disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @IBAction private func triggerTouchDown(_ sender: UIButton) {
        if let text = secondTextField.text, let seconds = Int(text) {
            addUserNotification(seconds: seconds)
        }
    }
    
    private func configureUI() {
        triggerButton.layer.cornerRadius = 6
        triggerButton.layer.borderWidth = 0.8
        triggerButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func addUserNotification(seconds: Int) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        for i in 0..<4 {
            let content = UNMutableNotificationContent()
            // repeat이 true일 때는 interval이 60이 넘어야 정상 작동함
            var trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            
            // 아이콘위 숫자
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            // 유저 노티의 소리(커스텀 파일 가능)
            //content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: fileName))
            // 알람의 종류에 따라 분류 가능
            content.threadIdentifier = Identifier.interval.rawValue
            // 알람에 들어가는 기본적인 내용들
            content.title = "단계별 알람"
            
            do {
                guard let path = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
                    return
                }
                let url = URL(fileURLWithPath: path.path)
                
                try player = AVAudioPlayer(contentsOf: url)
                
                let offset: Double
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds + i * 15), repeats: false)
                offset = player!.deviceCurrentTime + Double(seconds) + Double(i * 15)
                
                if i == 3 {
                    content.subtitle = "최종 단계 알람"
                    content.body = "이건 최종단계 알람이야!"
                    player?.numberOfLoops = -1
                    player?.volume = 1
                } else {
                    content.subtitle = "\(i+1) 단계 알람"
                    content.body = "이건 \(i+1)단계 알람이야!"
                    player?.numberOfLoops = 0
                    player?.volume = 0.15 * Float(i+1)
                }
                
                player?.delegate = self
                player?.prepareToPlay()
                player?.play(atTime: offset)
                sceneDelegate.audioPlayers.append(player!)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            userNotificationCenter.add(request) {
                guard let error = $0 else {
                    return
                }
                
                NSLog(error.localizedDescription)
            }
        }
    }
}

extension IntervalViewController: AVAudioPlayerDelegate {
}
