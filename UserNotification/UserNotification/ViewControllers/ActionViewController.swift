//
//  ActionViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import UserNotifications
import Combine

final class ActionViewController: UIViewController {
    private var disposeBag = Set<AnyCancellable>()
    private let userNotificationPublicist = UserNotificationPublicist()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var attachmentSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUserNotificationCategories()
        
        userNotificationPublicist
            .responseSubject
            .subscribe(on: DispatchQueue.main, options: nil)
            .sink { [weak self] response in
                let alertController = UIAlertController(title: response.actionIdentifier, message: "\(response.actionIdentifier) hello!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "finish", style: .default, handler: nil)
                alertController.addAction(alertAction)
                
                // action identifier에 따른 구분, action으로 넘어온 delegate아니면 그냥 alert를 띄우지 않음
                switch response.actionIdentifier {
                case ActionIdentifier.destructive.rawValue, ActionIdentifier.normal.rawValue:
                    self?.present(alertController, animated: true, completion: nil)
                default:
                    break
                }
            }
            .store(in: &disposeBag)
    }
    
    @IBAction func triggerTouchDown(_ sender: UIButton) {
        triggerUserNotification(case: attachmentSegmentControl.selectedSegmentIndex)
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
    
    private func triggerUserNotification(case index: Int) {
        let fileName = "example"
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        content.threadIdentifier = Identifier.action.rawValue
        let url: URL?
        // segment control에 맞게 url을 가져오는 과정
        switch index {
        case 0:
            url = Bundle.main.url(forResource: fileName, withExtension: FileType.jpg.rawValue)
        case 1:
            url = Bundle.main.url(forResource: fileName, withExtension: FileType.mp4.rawValue)
        default:
            url = Bundle.main.url(forResource: fileName, withExtension: FileType.mp3.rawValue)
        }
        
        guard let url = url, let attachment = try? UNNotificationAttachment(identifier: fileName, url: url, options: nil)  else {
            return
        }
        content.attachments = [attachment]
        content.title = "Action UN"
        content.body = "\(index)의 Action"
        // action을 사용하기 위해서는 category identifier를 등록한 identifier와 일치하는 제목으로 맞춰야함
        content.categoryIdentifier = CategoryIdentifier.test.rawValue
        let request = UNNotificationRequest(identifier: url.path, content: content, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            guard let error = error else {
                return
            }
            
            NSLog(error.localizedDescription)
        }
    }
    
    // 유저 노티피케이션의 카테고리 설정(Action 추가)
    private func configureUserNotificationCategories() {
        let circle = "circle"
        // 제목, option(3가지), icon 설정 가능
        let normalAction = UNNotificationAction(identifier: ActionIdentifier.normal.rawValue, title: ActionIdentifier.normal.rawValue, options: [.foreground, .authenticationRequired], icon: UNNotificationActionIcon(systemImageName: circle))
        let destructiveAction = UNNotificationAction(identifier: ActionIdentifier.destructive.rawValue, title: ActionIdentifier.destructive.rawValue, options: [.destructive], icon: UNNotificationActionIcon(systemImageName: circle))
        // 이러한 카테고리의 액션들 설정 가능
        let category = UNNotificationCategory(identifier: CategoryIdentifier.test.rawValue, actions: [normalAction, destructiveAction], intentIdentifiers: [], options: [])
        
        // 센터에 추가
        userNotificationCenter.setNotificationCategories([category])
    }
}
