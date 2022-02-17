//
//  ListViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/17.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private var viewModel = ListViewModel()
    private var disposeBag = Set<AnyCancellable>()
    private let userNotificationPublicist = UserNotificationPublicist()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNotificationPublicist
            .requestSubject
            .receive(on: DispatchQueue.global(), options: nil)
            .map { results -> [UserRequest] in
                return results.map { value -> UserRequest in
                    let time: String
                    if let trigger = value.trigger as? UNCalendarNotificationTrigger {
                        time = "\(trigger.dateComponents.year ?? 0)년 \(trigger.dateComponents.month ?? 0)월 \(trigger.dateComponents.day ?? 0)일 \(trigger.dateComponents.hour ?? 0):\(trigger.dateComponents.minute ?? 0)"
                    } else {
                        time = "없음"
                    }
                    
                    return UserRequest(identifier: value.identifier, title: value.content.title, time: time)
                }
            }.receive(on: RunLoop.main, options: nil)
            .sink {
                self.viewModel.add(requests: $0)
                self.listTableView.reloadData()
            }.store(in: &disposeBag)
        
        userNotificationPublicist
            .responseSubject
            .sink { [weak self] _ in
                self?.userNotificationPublicist.pendingRequests()
            }.store(in: &disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNotificationPublicist.pendingRequests()
    }
    
    @IBAction func deleteTouchDown(_ sender: UIButton) {
        userNotificationPublicist.deleteAllRequest()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        cell.configure(value: viewModel.requests[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userNotificationPublicist.deleteRequest(identifiers: [viewModel.requests[indexPath.row].identifier])
        }
    }
}
