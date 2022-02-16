//
//  ActionViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import UserNotifications

class ActionViewController: UIViewController {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var attachmentSegmentControl: UISegmentedControl!
    @IBOutlet weak var actionSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNotificationAuth()
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
    
    private func configureUI() {
        triggerButton.layer.cornerRadius = 6
        triggerButton.layer.borderWidth = 0.8
        triggerButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
