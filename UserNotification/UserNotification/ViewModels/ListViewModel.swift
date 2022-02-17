//
//  ListViewModel.swift
//  UserNotification
//
//  Created by Nick on 2022/02/17.
//

import Foundation
import Combine

struct ListViewModel {
    var requests: [UserRequest] = []
    
    mutating func add(requests: [UserRequest]) {
        self.requests = requests
    }
}
