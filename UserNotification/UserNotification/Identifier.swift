//
//  Identifier.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import Foundation

enum FileType: String {
    case jpg, mp4, mp3
}

enum Identifier: String {
    case interval, calendar, action
}

enum ActionIdentifier: String {
    case normal, destructive
}

enum AttachmentIdentifier: String {
    case image, movie, sound
}

enum CategoryIdentifier: String {
    case test
}
