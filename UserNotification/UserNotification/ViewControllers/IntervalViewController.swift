//
//  ViewController.swift
//  UserNotification
//
//  Created by Nick on 2022/02/16.
//

import UIKit
import AVFoundation
import MediaPlayer
import Combine

final class IntervalViewController: UIViewController {
    private var timerSubscription: AnyCancellable?
    private var disposeBag = Set<AnyCancellable>()
    private var dates: Set<String> = []
    private var player: AVAudioPlayer?
    private let userNotificationPublicist = UserNotificationPublicist()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var secondTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNotificationPublicist
            .listSubject
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] requests in
                self?.stopButton.isHidden = requests.isEmpty
            }.store(in: &disposeBag)
        
        // 노래를 안겹치게 만들기 위한 로직
        // Timer 사용
        Timer.publish(every: 0.5, tolerance: nil, on: RunLoop.main, in: .default, options: nil)
            .autoconnect()
            .sink { _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                
                var index: Int = 0
                
                for i in stride(from: sceneDelegate.audioPlayers.count-1, to: 0, by: -1) {
                    if sceneDelegate.audioPlayers[i].audioPlayer.currentTime != 0 {
                        index = i
                        break
                    }
                }
                for i in 0..<index {
                    if 0 == index {
                        break
                    }
                    sceneDelegate.audioPlayers[i].audioPlayer.stop()
                }
                for _ in 0..<index {
                    if 0 == index {
                        break
                    }
                    sceneDelegate.audioPlayers.removeFirst()
                }
            }.store(in: &disposeBag)
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
        
        timerSubscription = Timer.publish(every: 1, tolerance: nil, on: RunLoop.main, in: .default, options: nil)
            .autoconnect()
            .sink { [weak self] val in
                self?.userNotificationPublicist.pendingRequests()
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerSubscription?.cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @IBAction func stopTouchDown(_ sender: UIButton) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.audioPlayers.forEach {
            if $0.startDate <= Date() {
                $0.audioPlayer.stop()
                self.dates.insert($0.startDate.description)
                sceneDelegate.audioPlayers.removeFirst()
            }
        }
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: Array(dates))
        dates.removeAll()
    }
    
    @IBAction private func triggerTouchDown(_ sender: UIButton) {
        if let text = secondTextField.text, let seconds = Int(text) {
            addUserNotification(seconds: seconds)
        }
    }
    
    private func addUserNotification(seconds: Int) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        let date = Date()
        
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
                sceneDelegate.audioPlayers.append(.init(audioPlayer: player!, startDate: date))
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)
            
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
