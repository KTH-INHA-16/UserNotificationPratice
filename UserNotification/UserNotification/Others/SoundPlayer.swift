//
//  SoundPlayer.swift
//  UserNotification
//
//  Created by 김태훈 on 2022/03/10.
//

import Foundation
import AudioToolbox

public final class SoundPlayer {
    private let sound: SystemSoundID
    private var playing = false
    private var finished = false
    private let limit: Int

    public init(sound: SystemSoundID = kSystemSoundID_Vibrate,
                limit: Int = 8) {
        self.sound = sound
        self.limit = limit
    }

    public func play() {
        guard !playing else {
            return
        }
        playing = true

        play(idx: 0)
    }
    
    public func isFinish() -> Bool {
        finished
    }

    private func play(idx: Int) {
        guard idx < limit else {
            finished = true
            return
        }
        AudioServicesPlayAlertSound(sound)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.play(idx: idx + 1)
        }
    }
}
