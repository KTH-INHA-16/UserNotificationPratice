//
//  ViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import Combine

final class IntervalViewController: UIViewController {
    private var disposeBag = Set<AnyCancellable>()
    private let userNotificationPublicist = UserNotificationPublicist()
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
        let content = UNMutableNotificationContent()
        // repeat이 true일 때는 interval이 60이 넘어야 정상 작동함
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        
        // 아이콘위 숫자
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        // 유저 노티의 소리(커스텀 파일 가능)
        content.sound = .defaultCritical
        // 알람의 종류에 따라 분류 가능
        content.threadIdentifier = Identifier.interval.rawValue
        // 알람에 들어가는 기본적인 내용들
        content.title = "Time Interval 알람"
        content.subtitle = "\(seconds)초 이전에 동작"
        content.body = "이건 \(seconds)초전에 설정해 놓았던 알람이야!"
        
        let request = UNNotificationRequest(identifier: Identifier.interval.rawValue, content: content, trigger: trigger)
        
        userNotificationCenter.add(request) {
            guard let error = $0 else {
                return
            }
            
            NSLog(error.localizedDescription)
        }
    }
}
