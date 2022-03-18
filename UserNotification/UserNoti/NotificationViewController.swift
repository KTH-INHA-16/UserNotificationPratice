//
//  NotificationViewController.swift
//  UserNoti
//
//  Created by 김태훈 on 2022/03/17.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
        subtitleLabel.text = notification.request.content.subtitle
    }

}
