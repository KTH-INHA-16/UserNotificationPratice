//
//  CalendarViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit

final class CalendarViewController: UIViewController {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var notificationDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNotificationAuth()
    }
    
    @IBAction private func triggerTouchDown(_ sender: UIButton) {
        userNotificationTrigger(date: notificationDatePicker.date)
    }
    
    private func configureUI() {
        triggerButton.layer.cornerRadius = 6
        triggerButton.layer.borderWidth = 0.8
        triggerButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func userNotificationAuth() {
        userNotificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { success, error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            //상황에 따라 무언가 하게됨
            switch success {
            case true:
                break
            case false:
                break
            }
        }
    }
    
    private func userNotificationTrigger(date: Date) {
        let content = UNMutableNotificationContent()
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        content.threadIdentifier = Identifier.calendar.rawValue
        // 아이콘위 숫자
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        // 알람에 들어가는 기본적인 내용들
        content.title = "Calendar Interval 알람"
        content.subtitle = "\(date.formatted())에 동작"
        content.body = "이건 \(date.formatted())에 동작하는 알람이야!"
        
        let request = UNNotificationRequest(identifier: Identifier.calendar.rawValue, content: content, trigger: trigger)
        
        userNotificationCenter.add(request) {
            guard let error = $0 else {
                return
            }
            
            NSLog(error.localizedDescription)
        }
    }
}